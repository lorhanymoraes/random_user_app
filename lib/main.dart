// Importa dependências essenciais do Flutter, Modular (para rotas e DI), e dotenv (variáveis de ambiente)

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:random_user_app/app_module.dart';
import 'package:random_user_app/app_widget.dart';

/// Função principal que inicializa o app Flutter
/// - Garante que o binding do Flutter está inicializado
/// - Carrega variáveis de ambiente conforme o modo de build
/// - Inicializa o Modular (injeção de dependências e rotas)
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Necessário para inicialização de plugins antes do runApp

  await _initENV(); // Carrega variáveis de ambiente - segurança do app;

  // ModularApp inicializa o módulo principal (AppModule) e o widget raiz (AppWidget)
  runApp(ModularApp(module: AppModule(), child: AppWidget()));
}

/// Carrega o arquivo de variáveis de ambiente conforme o modo de build
/// - Em modo release, carrega .env.production
/// - Em modo debug, carrega .env.development
_initENV() async {
  const envFile = kReleaseMode
      ? 'assets/.env.production'
      : 'assets/.env.development';
  await dotenv.load(fileName: envFile);
}
