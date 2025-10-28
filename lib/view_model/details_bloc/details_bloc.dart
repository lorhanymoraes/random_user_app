import 'package:flutter_bloc/flutter_bloc.dart';

/// Bloc responsável por gerenciar o estado dos detalhes de um usuário.
/// Utiliza SharedPreferencesService para persistência local.
import 'package:random_user_app/services/shared_preferences/shared_preferences_service.dart';
import 'details_event.dart';
import 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final SharedPreferencesService sharedPrefs;

  /// Construtor do DetailsBloc, inicializa os eventos suportados.
  DetailsBloc(this.sharedPrefs) : super(DetailsInitial()) {
    on<CheckPersistedStatus>(_onCheckStatus);
    on<TogglePersistedUser>(_onToggleUser);
  }

  /// Verifica se o usuário está persistido localmente.
  Future<void> _onCheckStatus(
    CheckPersistedStatus event,
    Emitter<DetailsState> emit,
  ) async {
    emit(DetailsLoading());
    try {
      final users = await sharedPrefs.getPersistedUsers();
      final isPersisted = users.any((u) => u.email == event.user.email);
      emit(DetailsLoaded(isPersisted));
    } catch (_) {
      emit(DetailsError("Erro ao verificar usuário."));
    }
  }

  /// Alterna o status de persistência do usuário (adiciona ou remove).
  Future<void> _onToggleUser(
    TogglePersistedUser event,
    Emitter<DetailsState> emit,
  ) async {
    final currentState = state;

    // Recupera se o usuário já está persistido
    final isPersisted = switch (currentState) {
      DetailsLoaded() => currentState.isPersisted,
      DetailsSuccess() => currentState.isPersisted,
      DetailsError() => currentState.isPersisted ?? false,
      _ => false,
    };

    emit(DetailsLoading());

    try {
      if (isPersisted) {
        await sharedPrefs.removeUser(event.user);
        emit(DetailsSuccess("Usuário removido dos persistidos.", false));
      } else {
        await sharedPrefs.saveUser(event.user);
        emit(DetailsSuccess("Usuário salvo com sucesso.", true));
      }
    } catch (_) {
      emit(
        DetailsError("Erro ao atualizar usuário.", isPersisted: isPersisted),
      );
    }
  }
}
