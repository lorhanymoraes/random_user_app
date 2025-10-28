part of 'home_bloc.dart';

/// Estados possíveis do HomeBloc, representando as diferentes fases da tela inicial.

/// Classe base para todos os estados do HomeBloc.
abstract class HomeState {}

/// Estado inicial da tela, antes de buscar o usuário.
class UserInitial extends HomeState {}

/// Estado que indica que o usuário foi carregado com sucesso.
class UserLoaded extends HomeState {
  final User user;
  UserLoaded(this.user);
}

/// Estado de erro ao buscar o usuário.
class UserError extends HomeState {
  final String message;
  UserError(this.message);
}
