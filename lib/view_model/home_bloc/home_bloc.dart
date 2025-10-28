import 'package:flutter_bloc/flutter_bloc.dart';

/// Bloc responsável por gerenciar o estado da tela inicial e buscar usuários aleatórios.
import 'package:flutter_modular/flutter_modular.dart';
import 'package:random_user_app/domain/usecases/get_random_user_usecase.dart';
import 'package:random_user_app/services/shared_preferences/shared_preferences_service.dart';
import 'dart:async';
import '../../domain/models/user_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SharedPreferencesService repository;
  Timer? _ticker;

  /// Construtor do HomeBloc, inicializa os eventos suportados.
  HomeBloc(this.repository) : super(UserInitial()) {
    on<FetchUser>(_onFetchUser);
    on<StartTicker>(_onStartTicker);
    on<StopTicker>(_onStopTicker);
  }

  /// Busca um usuário aleatório usando o usecase GetRandomUserUsecase.
  void _onFetchUser(FetchUser event, Emitter<HomeState> emit) async {
    try {
      final user = await Modular.get<GetRandomUserUsecase>().call();
      user.fold(
        (error) => emit(UserError(error.toString())),
        (user) => emit(UserLoaded(user)),
      );
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  /// Inicia o timer para buscar usuários periodicamente.
  void _onStartTicker(StartTicker event, Emitter<HomeState> emit) {
    // Evita múltiplos timers rodando ao mesmo tempo
    _ticker?.cancel();
    _ticker = Timer.periodic(Duration(seconds: 5), (_) => add(FetchUser()));
  }

  /// Para o timer de busca periódica de usuários.
  void _onStopTicker(StopTicker event, Emitter<HomeState> emit) {
    _ticker?.cancel();
    _ticker = null;
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
