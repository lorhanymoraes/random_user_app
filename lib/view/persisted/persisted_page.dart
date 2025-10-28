import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:random_user_app/services/shared_preferences/shared_preferences_service.dart';
import 'package:random_user_app/view/components/app_bar.dart';
import 'package:random_user_app/view/components/user_avatar.dart';
import 'package:random_user_app/view_model/persisted_bloc/persisted_bloc.dart';
import 'package:random_user_app/view_model/persisted_bloc/persisted_state.dart';
import 'package:random_user_app/view_model/persisted_bloc/persited_event.dart';

class PersistedPage extends StatelessWidget {
  const PersistedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PersistedBloc(Modular.get<SharedPreferencesService>())
            ..add(LoadPersistedUsers()),
      child: Scaffold(
        appBar: appBarCustom(
          context: context,
          isHomePage: false,
          title: "Usuários Persistidos",
        ),
        backgroundColor: Colors.white,
        body: BlocConsumer<PersistedBloc, PersistedState>(
          listener: (context, state) {
            if (state is PersistedLoaded && state.actionMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.actionMessage!)));
              // Limpa a mensagem para não disparar de novo
              state = state.copyWith(actionMessage: null);
            }
          },
          builder: (context, state) {
            final bloc = BlocProvider.of<PersistedBloc>(context);

            //Renderização condicional baseada no estado atual
            // Estado inicial - carregando;
            if (state is PersistedLoading) {
              return const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            }
            // Caso haja erro ao carregar;
            if (state is PersistedError) {
              return Center(child: Text(state.message));
            }
            // Se carregou mas a lista de usuários está vazia;
            if (state is PersistedLoaded) {
              if (state.users.isEmpty) {
                return const Center(child: Text("Nenhum usuário persistido."));
              }
              // Lista de usuários persistidos carregada com sucesso;

              return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (_, index) {
                  final user = state.users[index];
                  final isDeleting = state.deletingUser == user;

                  return Semantics(
                    label:
                        "Usuário ${user.firstName} ${user.lastName}, email: ${user.email}",
                    hint: isDeleting
                        ? "Removendo usuário"
                        : "Clique no ícone de lixeira para excluir",
                    child: ListTile(
                      leading: UserAvatar(imageUrl: user.picture, radius: 30),
                      title: Text("${user.firstName} ${user.lastName}"),
                      subtitle: Text(user.email),
                      trailing: isDeleting
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (dialogContext) => AlertDialog(
                                    title: const Text("Confirmação"),
                                    content: const Text(
                                      "Tem certeza que deseja excluir este usuário?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(
                                          dialogContext,
                                        ).pop(false),
                                        child: const Text("Cancelar"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => Navigator.of(
                                          dialogContext,
                                        ).pop(true),
                                        child: const Text("Excluir"),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmed ?? false) {
                                  bloc.add(RemovePersistedUser(user));
                                }
                              },
                            ),
                      onTap: () => Modular.to
                          .pushNamed('/details', arguments: user)
                          .then((_) => bloc.add(LoadPersistedUsers())),
                    ),
                  );
                },
              );
            }
            //Fallback de erro inesperado.
            return const Center(child: Text("Problemas ao carregar usuários."));
          },
        ),
      ),
    );
  }
}
