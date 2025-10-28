import 'package:flutter_modular/flutter_modular.dart';
import 'package:random_user_app/domain/external/datasources/get_random_user_datasource.dart';
import 'package:random_user_app/domain/external/datasources/get_random_user_datasource_impl.dart';
import 'package:random_user_app/domain/infra/repositories/get_random_user_repository.dart';
import 'package:random_user_app/domain/infra/repositories/get_random_user_repository_impl.dart';
import 'package:random_user_app/domain/usecases/get_random_user_usecase.dart';
import 'package:random_user_app/services/shared_preferences/shared_preferences_service_impl.dart';
import 'package:random_user_app/view/splash/splash_page.dart';
import 'package:random_user_app/view_model/details_bloc/details_bloc.dart';
import 'package:random_user_app/view_model/persisted_bloc/persisted_bloc.dart';
import 'services/shared_preferences/shared_preferences_service.dart';
import 'view_model/home_bloc/home_bloc.dart';
import 'view/home/home_page.dart';
import 'view/details/details_page.dart';
import 'view/persisted/persisted_page.dart';

/// AppModule é o módulo principal do Flutter Modular
/// Responsável por registrar todas as dependências (serviços, datasources, repositories, usecases, blocs)
/// e definir as rotas principais do app.
class AppModule extends Module {
  @override
  void binds(i) {
    // Serviços: responsável por persistência local (SharedPreferences)
    i.addLazySingleton<SharedPreferencesService>(
      SharedPreferencesServiceImpl.new,
    );

    // DataSource: responsável por buscar dados da API externa
    i.addLazySingleton<GetRandomUserDatasource>(
      GetRandomUserDatasourceImpl.new,
    );

    // Repository: camada que faz a ponte entre DataSource e lógica de negócio
    i.addLazySingleton<GetRandomUserRepository>(
      () => GetRandomUserRepositoryImpl(i(), i()),
    );

    // Usecase: encapsula a regra de negócio de buscar usuário
    i.addLazySingleton<GetRandomUserUsecase>(
      () => GetRandomUserUsecaseImpl(i()),
    );

    // Blocs: gerenciam o estado das telas
    i.addLazySingleton<HomeBloc>(
      () => HomeBloc(i())..add(StartTicker()),
    ); // HomeBloc inicia o ticker ao ser criado
    i.addLazySingleton<PersistedBloc>(
      () => PersistedBloc(i()),
    ); // Gerencia usuários persistidos
    i.addLazySingleton<DetailsBloc>(
      () => DetailsBloc(i()),
    ); // Gerencia detalhes do usuário
  }

  @override
  void routes(r) {
    // Define as rotas principais do app
    r.child('/', child: (context) => SplashPage()); // Tela inicial (splash)
    r.child('/home', child: (context) => HomePage()); // Tela principal
    r.child(
      '/details',
      child: (context) => DetailsPage(),
    ); // Tela de detalhes do usuário
    r.child(
      '/persisted',
      child: (context) => PersistedPage(),
    ); // Tela de usuários persistidos
  }
}
