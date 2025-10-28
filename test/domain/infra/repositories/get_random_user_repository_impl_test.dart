import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:random_user_app/domain/infra/repositories/get_random_user_repository_impl.dart';
import 'package:random_user_app/domain/models/user_model.dart';
import 'package:random_user_app/domain/errors/user_general_erros.dart';
import 'package:random_user_app/domain/external/datasources/get_random_user_datasource.dart';
import 'package:random_user_app/services/shared_preferences/shared_preferences_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class MockDatasource extends Mock implements GetRandomUserDatasource {}

class MockPrefs extends Mock implements SharedPreferencesService {}

void main() {
  group('GetRandomUserRepositoryImpl', () {
    late MockDatasource datasource;
    late MockPrefs prefs;
    late GetRandomUserRepositoryImpl repository;

    setUp(() {
      datasource = MockDatasource();
      prefs = MockPrefs();
      repository = GetRandomUserRepositoryImpl(datasource, prefs);
      registerFallbackValue(http.Response('', 200));
    });

    test('deve retornar usuário quando API responde corretamente', () async {
      final userJson = {
        'gender': 'male',
        'name': {'first': 'John', 'last': 'Doe'},
        'email': 'john@email.com',
        'phone': '123',
        'cell': '456',
        'picture': {'large': 'url'},
        'id': {'name': 'ID', 'value': '1'},
        'dob': {'date': '2000-01-01', 'age': 25},
        'registered': {'date': '2020-01-01', 'age': 5},
        'location': {
          'street': {'number': 10, 'name': 'Main St'},
          'city': 'City',
          'state': 'State',
          'country': 'Country',
          'postcode': '00000',
          'coordinates': {'latitude': '1.0', 'longitude': '2.0'},
          'timezone': {'offset': '+1', 'description': 'desc'},
        },
        'nat': 'BR',
      };
      final response = http.Response(
        jsonEncode({
          'results': [userJson],
        }),
        200,
      );
      when(() => datasource.getRandomUser()).thenAnswer((_) async => response);
      final result = await repository.fetchRandomUser();
      expect(result.isRight(), true);
      expect(result.getOrElse(() => throw Exception('fail')).firstName, 'John');
    });

    test('deve retornar erro se status da API for diferente de 200', () async {
      final response = http.Response('erro', 404);
      when(() => datasource.getRandomUser()).thenAnswer((_) async => response);
      final result = await repository.fetchRandomUser();
      expect(result.isLeft(), true);
      expect(
        result.fold((l) => l, (r) => null),
        isA<UserErrorInvalidResponse>(),
      );
    });

    test('deve retornar erro se body da API for vazio', () async {
      final response = http.Response('', 200);
      when(() => datasource.getRandomUser()).thenAnswer((_) async => response);
      final result = await repository.fetchRandomUser();
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<UserErrorEmptyResponse>());
    });

    test('deve retornar erro se results for vazio', () async {
      final response = http.Response('{"results": []}', 200);
      when(() => datasource.getRandomUser()).thenAnswer((_) async => response);
      final result = await repository.fetchRandomUser();
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<UserErrorParseJson>());
    });

    test('deve retornar usuário do cache se houver SocketException', () async {
      when(
        () => datasource.getRandomUser(),
      ).thenThrow(const SocketException('No Internet'));
      final user = User(
        gender: 'female',
        firstName: 'Ana',
        lastName: 'Silva',
        email: 'ana@email.com',
        phone: '333333',
        cell: '444444',
        picture: 'pic_url',
        idName: 'ID',
        idValue: '789',
        dobDate: '1985-05-05',
        dobAge: 40,
        registeredDate: '2015-05-05',
        registeredAge: 10,
        streetNumber: 30,
        streetName: 'Third St',
        city: 'Cidade',
        state: 'Estado',
        country: 'País',
        postcode: '22222',
        latitude: '5.0',
        longitude: '6.0',
        timezoneOffset: '+3',
        timezoneDescription: 'desc3',
        nat: 'PT',
      );
      when(() => prefs.getPersistedUsers()).thenAnswer((_) async => [user]);
      final result = await repository.fetchRandomUser();
      expect(result.isRight(), true);
      expect(result.getOrElse(() => throw Exception('fail')).firstName, 'Ana');
    });

    test(
      'deve retornar erro se cache estiver vazio após SocketException',
      () async {
        when(
          () => datasource.getRandomUser(),
        ).thenThrow(const SocketException('No Internet'));
        when(() => prefs.getPersistedUsers()).thenAnswer((_) async => []);
        final result = await repository.fetchRandomUser();
        expect(result.isLeft(), true);
        expect(result.fold((l) => l, (r) => null), isA<UserErrorCacheEmpty>());
      },
    );
  });
}
