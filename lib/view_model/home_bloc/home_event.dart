part of 'home_bloc.dart';

/// Eventos que representam ações disparadas no HomeBloc.

/// Classe base para todos os eventos do HomeBloc.
abstract class HomeEvent {}

/// Evento para buscar um usuário aleatório.
class FetchUser extends HomeEvent {}

/// Evento para iniciar o timer de busca periódica de usuários.
class StartTicker extends HomeEvent {}

/// Evento para parar o timer de busca periódica de usuários.
class StopTicker extends HomeEvent {}
