import '../../domain/models/user_model.dart';

/// Eventos que representam ações disparadas no PersistedBloc.

/// Classe base para todos os eventos do PersistedBloc.
abstract class PersistedEvent {}

/// Evento para carregar os usuários persistidos localmente.
class LoadPersistedUsers extends PersistedEvent {}

/// Evento para remover um usuário da lista de persistidos.
class RemovePersistedUser extends PersistedEvent {
  final User user;
  RemovePersistedUser(this.user);
}
