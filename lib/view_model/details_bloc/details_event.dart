import '../../domain/models/user_model.dart';

/// Eventos que representam ações disparadas no DetailsBloc.

/// Classe base para todos os eventos do DetailsBloc.
abstract class DetailsEvent {}

/// Evento para verificar se o usuário está persistido localmente.
class CheckPersistedStatus extends DetailsEvent {
  final User user;
  CheckPersistedStatus(this.user);
}

/// Evento para alternar o status de persistência do usuário (adicionar ou remover).
class TogglePersistedUser extends DetailsEvent {
  final User user;
  TogglePersistedUser(this.user);
}
