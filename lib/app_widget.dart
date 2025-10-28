import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// AppWidget é o widget raiz do aplicativo
/// Responsável por configurar o MaterialApp com rotas gerenciadas pelo Modular
class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Random Users', // Título do app
      theme: ThemeData(primarySwatch: Colors.blue), // Tema principal
      routeInformationParser:
          Modular.routeInformationParser, // Parser de rotas do Modular
      routerDelegate: Modular.routerDelegate, // Delegate de rotas do Modular
    );
  }
}
