import 'package:random_user_app/domain/errors/user_errors.dart';

/// Erro genérico da aplicação, usado para mensagens customizadas
class UserErrorGeneric implements UserErrors {
  final String message;
  UserErrorGeneric(this.message);

  @override
  String toString() => message;
}

/// Erro lançado quando não é possível conectar à API
class UserErrorApiConnection implements UserErrors {
  @override
  String toString() => "Erro ao se conectar à API de usuários.";
}

/// Erro lançado quando a resposta da API é inválida
class UserErrorInvalidResponse implements UserErrors {
  @override
  String toString() => "Resposta inválida da API. Tente novamente mais tarde.";
}

/// Erro lançado ao tentar converter o JSON recebido da API
class UserErrorParseJson implements UserErrors {
  @override
  String toString() => "Erro ao processar os dados recebidos.";
}

/// Erro lançado quando a API retorna resposta vazia
class UserErrorEmptyResponse implements UserErrors {
  @override
  String toString() => "Nenhum usuário foi retornado pela API.";
}

/// Erro lançado ao tentar salvar usuário no SharedPreferences
class UserErrorPersistenceSave implements UserErrors {
  @override
  String toString() => "Erro ao salvar usuário na persistência local.";
}

/// Erro lançado ao tentar ler usuários do SharedPreferences
class UserErrorPersistenceRead implements UserErrors {
  @override
  String toString() => "Erro ao carregar usuários persistidos.";
}

/// Erro lançado quando não há dados salvos localmente
class UserErrorPersistenceEmpty implements UserErrors {
  @override
  String toString() => "Nenhum dado salvo localmente.";
}

/// Erro lançado ao tentar remover usuário da persistência
class UserErrorPersistenceRemove implements UserErrors {
  @override
  String toString() => "Erro ao remover usuário da persistência.";
}

/// Erro lançado ao iniciar o ticker (atualização automática de usuários)
class UserErrorTickerStart implements UserErrors {
  @override
  String toString() => "Erro ao iniciar o atualizador automático de usuários.";
}

/// Erro lançado quando o cache está vazio
class UserErrorCacheEmpty implements UserErrors {
  @override
  String toString() => "Sem cache disponível.";
}

/// Erro lançado ao falhar na conexão com a internet
class UserErrorCacheFailure implements UserErrors {
  @override
  String toString() => "Falha ao conectar à internet.";
}
