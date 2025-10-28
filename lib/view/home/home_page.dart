import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:random_user_app/view/components/app_bar.dart';
import 'package:random_user_app/view/components/user_avatar.dart';
import '../../view_model/home_bloc/home_bloc.dart';
import '../../domain/models/user_model.dart';

/// Tela principal do app, exibe um usuário aleatório
/// Utiliza BLoC para gerenciar o estado da busca de usuário
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Modular.get<HomeBloc>(), // Injeta o HomeBloc
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBarCustom(
          context: context,
          isHomePage: true,
          title: "Usuários",
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          bloc: Modular.get<HomeBloc>(), // Observa o estado do HomeBloc
          builder: (context, state) {
            if (state is UserLoaded) {
              // Usuário carregado com sucesso
              User user = state.user;
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 50,
                ),
                child: Center(
                  child: Semantics(
                    label:
                        "Avatar do usuário ${user.firstName} ${user.lastName}",
                    hint: "Clique para ver detalhes",
                    button: true,
                    child: GestureDetector(
                      onTap: () {
                        // Navega para tela de detalhes passando o usuário
                        Modular.to.pushNamed('details', arguments: user);
                      },
                      child: Column(
                        children: [
                          UserAvatar(
                            imageUrl: user.picture,
                            radius: 80,
                          ), // Avatar do usuário
                          SizedBox(height: 10),
                          Text("${user.firstName} ${user.lastName}"), // Nome
                          Text(user.email), // Email
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else if (state is UserError) {
              // Exibe mensagem de erro
              return Center(child: Text(state.message));
            }
            // Exibe loading enquanto carrega
            return Center(
              child: const LinearProgressIndicator(
                color: Colors.blueAccent,
                backgroundColor: Colors.black12,
                minHeight: 4,
              ),
            );
          },
        ),
      ),
    );
  }
}
