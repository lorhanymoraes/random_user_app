// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_modular/flutter_modular.dart';
// import 'package:random_user_app/view_model/details_bloc/details_bloc.dart';
// import 'package:random_user_app/view_model/details_bloc/details_event.dart';
// import 'package:random_user_app/view_model/details_bloc/details_state.dart';
// import '../../domain/models/user_model.dart';
// import '../components/app_bar.dart';
// import '../components/user_avatar.dart';

// class DetailsPage extends StatelessWidget {
//   const DetailsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final User user = Modular.args.data;

//     return BlocProvider(
//       create: (_) =>
//           DetailsBloc(Modular.get())
//             ..add(CheckPersistedStatus(user)), // verifica se já está salvo
//       child: Scaffold(
//         appBar: appBarCustom(
//           context: context,
//           isHomePage: false,
//           title: "${user.firstName} ${user.lastName}",
//         ),
//         backgroundColor: Colors.white,
//         body: BlocConsumer<DetailsBloc, DetailsState>(
//           listener: (context, state) {
//             if (state is DetailsSuccess || state is DetailsError) {
//               final message = state is DetailsSuccess
//                   ? state.message
//                   : (state as DetailsError).message;

//               ScaffoldMessenger.of(
//                 context,
//               ).showSnackBar(SnackBar(content: Text(message)));
//             }
//           },
//           builder: (context, state) {
//             final bloc = BlocProvider.of<DetailsBloc>(context);
//             final details = user.groupedDetails();

//             bool isPersisted = false;
//             if (state is DetailsLoaded) {
//               isPersisted = state.isPersisted;
//             } else if (state is DetailsSuccess) {
//               isPersisted = state.isPersisted;
//             } else if (state is DetailsError) {
//               isPersisted = state.isPersisted ?? false;
//             }

//             return ListView(
//               padding: const EdgeInsets.all(16),
//               children: [
//                 Center(
//                   child: Semantics(
//                     label:
//                         "Avatar do usuário ${user.firstName} ${user.lastName}",
//                     image: true,
//                     child: UserAvatar(imageUrl: user.picture, radius: 80),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Semantics(
//                   label: isPersisted
//                       ? "Botão para remover o usuário dos persistidos"
//                       : "Botão para salvar o usuário nos persistidos",
//                   child: ElevatedButton(
//                     onPressed: () {
//                       bloc.add(TogglePersistedUser(user));
//                     },
//                     child: Row(
//                       mainAxisSize:
//                           MainAxisSize.min, // para não ocupar toda a largura
//                       children: [
//                         Icon(isPersisted ? Icons.delete : Icons.add, size: 20),
//                         const SizedBox(width: 6),

//                         Text(
//                           isPersisted
//                               ? "Remover dos persistidos"
//                               : "Salvar nos persistidos",
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 ...details.entries.map((group) {
//                   final groupName = group.key;
//                   final groupItems = group.value as Map<String, dynamic>;

//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     child: Padding(
//                       padding: const EdgeInsets.all(12),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Semantics(
//                             header: true,
//                             child: Text(
//                               groupName,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           ...groupItems.entries.map((item) {
//                             return Semantics(
//                               label: "${item.key}: ${item.value}",
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 2,
//                                 ),
//                                 child: Text("${item.key}: ${item.value}"),
//                               ),
//                             );
//                           }),
//                         ],
//                       ),
//                     ),
//                   );
//                 }),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:random_user_app/view_model/details_bloc/details_bloc.dart';
import 'package:random_user_app/view_model/details_bloc/details_event.dart';
import 'package:random_user_app/view_model/details_bloc/details_state.dart';
import '../../domain/models/user_model.dart';
import '../components/app_bar.dart';
import '../components/user_avatar.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final Map<String, bool> _expandedGroups = {};

  @override
  void initState() {
    super.initState();
    // “Informações Básicas” começa expandido
    _expandedGroups["Informações Básicas"] = true;
  }

  @override
  Widget build(BuildContext context) {
    final User user = Modular.args.data;

    return BlocProvider(
      create: (_) =>
          DetailsBloc(Modular.get())
            ..add(CheckPersistedStatus(user)), // verifica se já está salvo
      child: Scaffold(
        appBar: appBarCustom(
          context: context,
          isHomePage: false,
          title: "${user.firstName} ${user.lastName}",
        ),
        backgroundColor: Colors.white,
        body: BlocConsumer<DetailsBloc, DetailsState>(
          listener: (context, state) {
            if (state is DetailsSuccess || state is DetailsError) {
              final message = state is DetailsSuccess
                  ? state.message
                  : (state as DetailsError).message;

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            }
          },
          builder: (context, state) {
            final bloc = BlocProvider.of<DetailsBloc>(context);
            final details = user.groupedDetails();

            bool isPersisted = false;
            if (state is DetailsLoaded) {
              isPersisted = state.isPersisted;
            } else if (state is DetailsSuccess) {
              isPersisted = state.isPersisted;
            } else if (state is DetailsError) {
              isPersisted = state.isPersisted ?? false;
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: Semantics(
                    label:
                        "Avatar do usuário ${user.firstName} ${user.lastName}",
                    image: true,
                    child: UserAvatar(imageUrl: user.picture, radius: 80),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => bloc.add(TogglePersistedUser(user)),
                  icon: Icon(isPersisted ? Icons.delete : Icons.add),
                  label: Text(
                    semanticsLabel: isPersisted
                        ? "Remover dos persistidos"
                        : "Salvar nos persistidos",
                    isPersisted
                        ? "Remover dos persistidos"
                        : "Salvar nos persistidos",
                  ),
                ),
                const SizedBox(height: 20),

                /// Cards expansíveis
                ...details.entries.map((group) {
                  final groupName = group.key;
                  final groupItems = group.value as Map<String, dynamic>;
                  final isExpanded = _expandedGroups[groupName] ?? false;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ExpansionTile(
                      shape: const RoundedRectangleBorder(
                        side: BorderSide.none, // remove linhas
                      ),
                      title: Semantics(
                        label: groupName,
                        child: Text(
                          groupName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      initiallyExpanded: isExpanded,
                      onExpansionChanged: (expanded) {
                        setState(() {
                          _expandedGroups[groupName] = expanded;
                        });
                      },
                      children: [
                        const Divider(height: 1),
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: groupItems.entries.map((item) {
                                //Verificamos se o valor é null, se for, tratamos para o usuário
                                final value =
                                    (item.value == null ||
                                        item.value.toString().trim().isEmpty ||
                                        item.value.toString().toLowerCase() ==
                                            'null')
                                    ? 'S/N'
                                    : item.value.toString();
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Text(
                                    "${item.key}: $value",
                                    style: const TextStyle(fontSize: 14),
                                    textAlign: TextAlign.start,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}
