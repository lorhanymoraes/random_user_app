/// Estados possíveis do DetailsBloc, representando as diferentes fases da tela de detalhes.
abstract class DetailsState {}

/// Estado inicial da tela de detalhes.
class DetailsInitial extends DetailsState {}

/// Estado de carregamento dos dados do usuário.
class DetailsLoading extends DetailsState {}

/// Estado que indica se o usuário está persistido localmente.
class DetailsLoaded extends DetailsState {
  final bool isPersisted; // Usuário já está salvo
  DetailsLoaded(this.isPersisted);
}

/// Estado de sucesso ao realizar uma ação (ex: persistir ou remover usuário).
class DetailsSuccess extends DetailsState {
  final String message;
  final bool isPersisted;
  DetailsSuccess(this.message, this.isPersisted);
}

/// Estado de erro ao realizar uma ação ou carregar dados.
class DetailsError extends DetailsState {
  final String message;
  final bool? isPersisted;
  DetailsError(this.message, {this.isPersisted});
}
