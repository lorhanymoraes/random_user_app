import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:random_user_app/domain/errors/user_errors.dart';
import 'package:random_user_app/domain/errors/user_general_erros.dart';
import 'package:random_user_app/domain/infra/repositories/get_random_user_repository.dart';
import 'package:random_user_app/domain/models/user_model.dart';
import 'package:random_user_app/domain/external/datasources/get_random_user_datasource.dart';
import 'package:random_user_app/services/shared_preferences/shared_preferences_service.dart';

/// Repository Strategy
/// Estratégia: busca da API, fallback para cache local, persistência automática
class GetRandomUserRepositoryImpl implements GetRandomUserRepository {
  final GetRandomUserDatasource datasource;
  final SharedPreferencesService sharedPrefs;

  /// Recebe o datasource (API) e serviço de persistência (cache)
  GetRandomUserRepositoryImpl(this.datasource, this.sharedPrefs);

  @override
  Future<Either<UserErrors, User>> fetchRandomUser() async {
    try {
      // 1. Tenta buscar da API
      final response = await datasource.getRandomUser();

      // Valida status da resposta
      if (response.statusCode != 200) {
        return Left(UserErrorInvalidResponse());
      }

      // Valida se o corpo está vazio
      if (response.body.isEmpty) {
        return Left(UserErrorEmptyResponse());
      }

      // Decodifica JSON e valida estrutura
      final decoded = jsonDecode(response.body);
      final results = decoded['results'];

      if (results == null || results is! List || results.isEmpty) {
        return Left(UserErrorParseJson());
      }

      // Cria usuário a partir do primeiro resultado
      final user = User.fromJson(results.first);

      // 2. Persistência automática (sincroniza sempre que possível)
      try {
        await sharedPrefs.saveUser(user);
      } catch (_) {
        // Não impede o retorno;
      }

      return Right(user);
    } on SocketException {
      // 3. Fallback offline: busca do cache local
      try {
        final persisted = await sharedPrefs.getPersistedUsers();
        if (persisted.isNotEmpty) {
          return Right(persisted.last);
        }
        return Left(UserErrorCacheEmpty());
      } catch (e) {
        return Left(UserErrorCacheFailure());
      }
    } on FormatException {
      return Left(UserErrorParseJson());
    } on UserErrorGeneric catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UserErrorGeneric("Erro inesperado ao buscar usuário: $e"));
    }
  }
}
