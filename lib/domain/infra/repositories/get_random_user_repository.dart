import 'package:dartz/dartz.dart';
import 'package:random_user_app/domain/errors/user_errors.dart';
import 'package:random_user_app/domain/models/user_model.dart';

/// Interface para o repositório de usuários
/// Responsável por buscar usuário, seja da API ou do cache
abstract class GetRandomUserRepository {
  /// Busca um usuário aleatório, retornando erro ou sucesso
  Future<Either<UserErrors, User>> fetchRandomUser();
}
