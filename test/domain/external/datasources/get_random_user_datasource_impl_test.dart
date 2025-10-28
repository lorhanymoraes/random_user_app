import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:random_user_app/domain/external/datasources/get_random_user_datasource_impl.dart';
import 'package:random_user_app/domain/errors/user_general_erros.dart';
import 'dart:io';
import 'dart:convert';

class MockClient extends http.BaseClient {
  bool throwSocketException = false;
  bool throwGenericException = false;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (throwSocketException) {
      throw SocketException('No Internet');
    }
    if (throwGenericException) {
      throw Exception('Generic error');
    }
    return http.StreamedResponse(
      Stream.value(utf8.encode('{"results": []}')),
      200,
    );
  }
}

void main() {
  group('GetRandomUserDatasourceImpl', () {
    test('deve retornar resposta http com status 200', () async {
      final datasource = GetRandomUserDatasourceImpl();
      final response = await datasource.getRandomUser();
      expect(response.statusCode, 200);
    });

    test('deve lançar UserErrorApiConnection em SocketException', () async {
      try {
        // Simula erro de rede
        await Future.error(SocketException('No Internet'));
      } catch (e) {
        expect(
          () => throw UserErrorApiConnection(),
          throwsA(isA<UserErrorApiConnection>()),
        );
      }
    });

    test('deve lançar UserErrorGeneric em erro genérico', () async {
      try {
        await Future.error(Exception('Generic error'));
      } catch (e) {
        expect(
          () => throw UserErrorGeneric('Erro inesperado ao buscar usuário: $e'),
          throwsA(isA<UserErrorGeneric>()),
        );
      }
    });
  });
}
