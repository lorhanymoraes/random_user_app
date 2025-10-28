import 'package:dartz/dartz.dart';
import 'package:random_user_app/domain/errors/user_errors.dart';
import 'package:random_user_app/domain/infra/repositories/get_random_user_repository.dart';
import 'package:random_user_app/domain/models/user_model.dart';

/// Interface para o caso de uso de buscar usuário aleatório
abstract interface class GetRandomUserUsecase {
  /// Executa a ação de buscar usuário
  Future<Either<UserErrors, User>> call();
}

/// Implementação do caso de uso de buscar usuário aleatório
class GetRandomUserUsecaseImpl implements GetRandomUserUsecase {
  final GetRandomUserRepository repository;

  /// Recebe o repositório como dependência
  GetRandomUserUsecaseImpl(this.repository);

  @override
  Future<Either<UserErrors, User>> call() async {
    // Executa a busca de usuário via repositório
    return repository.fetchRandomUser();
  }
}
