import 'package:dartz/dartz.dart';
import 'package:random_user_app/domain/errors/user_errors.dart';

import '../../domain/models/user_model.dart';

/// Interface para serviço de persistência local usando SharedPreferences
/// Permite salvar, remover e buscar usuários persistidos no dispositivo
abstract class SharedPreferencesService {
  /// Salva um usuário localmente
  Future<Either<UserErrors, Unit>> saveUser(User user);

  /// Remove um usuário localmente
  Future<Either<UserErrors, Unit>> removeUser(User user);

  /// Busca todos os usuários persistidos
  Future<List<User>> getPersistedUsers();
}
