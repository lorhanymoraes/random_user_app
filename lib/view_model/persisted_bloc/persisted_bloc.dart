import 'package:flutter_bloc/flutter_bloc.dart';

/// Bloc responsável por gerenciar os usuários persistidos localmente.
import 'package:random_user_app/services/shared_preferences/shared_preferences_service.dart';
import 'package:random_user_app/view_model/persisted_bloc/persited_event.dart';
import 'persisted_state.dart';

class PersistedBloc extends Bloc<PersistedEvent, PersistedState> {
  /// Serviço de acesso ao SharedPreferences para persistência dos usuários.
  final SharedPreferencesService sharedPrefs;

  /// Construtor do PersistedBloc, inicializa os eventos suportados.
  PersistedBloc(this.sharedPrefs) : super(PersistedLoading()) {
    on<LoadPersistedUsers>(_onLoadUsers);
    on<RemovePersistedUser>(_onRemoveUser);
  }

  /// Carrega os usuários persistidos localmente.
  Future<void> _onLoadUsers(
    LoadPersistedUsers event,
    Emitter<PersistedState> emit,
  ) async {
    emit(PersistedLoading());
    try {
      final users = await sharedPrefs.getPersistedUsers();
      emit(PersistedLoaded(users));
    } catch (e) {
      emit(PersistedError("Erro ao carregar usuários."));
    }
  }

  /// Remove um usuário da lista de persistidos, com delay para feedback visual.
  Future<void> _onRemoveUser(
    RemovePersistedUser event,
    Emitter<PersistedState> emit,
  ) async {
    final currentState = state;
    if (currentState is PersistedLoaded) {
      try {
        // Marca usuário como deletando
        emit(currentState.copyWith(deletingUser: event.user));

        await Future.delayed(const Duration(seconds: 2));

        await sharedPrefs.removeUser(event.user);
        final users = await sharedPrefs.getPersistedUsers();

        // Atualiza lista e envia mensagem de ação
        emit(
          PersistedLoaded(
            users,
            actionMessage: "Usuário excluído com sucesso!",
          ),
        );
      } catch (e) {
        emit(
          currentState.copyWith(
            deletingUser: null,
            actionMessage: "Erro ao remover usuário.",
          ),
        );
      }
    }
  }
}
