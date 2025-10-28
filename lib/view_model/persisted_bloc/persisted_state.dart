import '../../domain/models/user_model.dart';

/// Estados possíveis do PersistedBloc, representando as diferentes fases da tela de usuários persistidos.

/// Classe base para todos os estados do PersistedBloc.
abstract class PersistedState {}

/// Estado inicial da tela de usuários persistidos.
class PersistedInitial extends PersistedState {}

/// Estado de carregamento dos usuários persistidos.
class PersistedLoading extends PersistedState {}

/// Estado que indica que os usuários persistidos foram carregados.
/// Pode conter usuário em processo de exclusão e mensagem de ação.
class PersistedLoaded extends PersistedState {
  final List<User> users;
  final User? deletingUser;
  final String? actionMessage; // mensagem de sucesso/erro da ação

  PersistedLoaded(this.users, {this.deletingUser, this.actionMessage});

  PersistedLoaded copyWith({
    List<User>? users,
    User? deletingUser,
    String? actionMessage,
  }) {
    return PersistedLoaded(
      users ?? this.users,
      deletingUser: deletingUser,
      actionMessage: actionMessage,
    );
  }
}

/// Estado de erro ao carregar ou manipular usuários persistidos.
class PersistedError extends PersistedState {
  final String message;
  PersistedError(this.message);
}
