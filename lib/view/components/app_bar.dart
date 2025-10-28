import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// APP BAR DINÂMICA
PreferredSizeWidget appBarCustom({
  required BuildContext context,
  required bool isHomePage,
  required String title,
}) {
  return AppBar(
    backgroundColor: Color(0xFF6930c3),
    title: Text(title, style: TextStyle(color: Colors.white)),
    elevation: 0,
    automaticallyImplyLeading: false,
    toolbarHeight: 100,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
    ),
    leading: !isHomePage
        ? Semantics(
            label: 'Botão de voltar',
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Modular.to.pop(),
              tooltip: "Voltar",
            ),
          )
        : null,

    actions: isHomePage
        ? [
            Semantics(
              label: 'Botão para abrir a tela de usuários persistidos',
              child: IconButton(
                icon: Icon(Icons.storage, color: Colors.white),
                onPressed: () => Modular.to.pushNamed('/persisted'),
                tooltip: "Abrir tela de Usuários Persistidos",
              ),
            ),
          ]
        : [],
  );
}
