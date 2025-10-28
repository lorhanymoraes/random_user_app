import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:random_user_app/domain/errors/user_errors.dart';
import 'package:random_user_app/domain/errors/user_general_erros.dart';
import 'package:random_user_app/domain/models/user_model.dart';

import 'package:random_user_app/services/shared_preferences/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementação do serviço de persistência usando SharedPreferences
/// Permite salvar, remover e buscar usuários localmente no dispositivo
class SharedPreferencesServiceImpl implements SharedPreferencesService {
  // Chave utilizada para armazenar a lista de usuários no SharedPreferences
  static final String keyUsers =
      dotenv.env['PERSISTED_ACCOUNTS_KEY'] ?? 'persisted_users';

  /// Salva um usuário na lista persistida, evitando duplicidade pelo idValue
  @override
  Future<Either<UserErrors, Unit>> saveUser(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final users = prefs.getStringList(keyUsers) ?? [];

      // Verifica se o usuário já existe pelo idValue
      final exists = users.any(
        (u) => User.fromJson(jsonDecode(u)).idValue == user.idValue,
      );

      if (!exists) {
        users.add(jsonEncode(user.toJson()));
        await prefs.setStringList(keyUsers, users);
      }

      return const Right(unit);
    } catch (e) {
      return Left(UserErrorPersistenceSave());
    }
  }

  /// Remove um usuário da lista persistida pelo idValue
  @override
  Future<Either<UserErrors, Unit>> removeUser(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final users = prefs.getStringList(keyUsers) ?? [];

      users.removeWhere(
        (u) => User.fromJson(jsonDecode(u)).idValue == user.idValue,
      );

      await prefs.setStringList(keyUsers, users);
      return const Right(unit);
    } catch (e) {
      return Left(UserErrorPersistenceRemove());
    }
  }

  /// Retorna todos os usuários persistidos localmente
  @override
  Future<List<User>> getPersistedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> users = prefs.getStringList(keyUsers) ?? [];
    return users.map((u) => User.fromJson(jsonDecode(u))).toList();
  }
}
