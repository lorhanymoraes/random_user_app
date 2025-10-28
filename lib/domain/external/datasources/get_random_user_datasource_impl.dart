import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:random_user_app/domain/errors/user_general_erros.dart';
import 'package:random_user_app/domain/external/datasources/get_random_user_datasource.dart';

/// Implementação do datasource que busca usuário na API Random User
class GetRandomUserDatasourceImpl implements GetRandomUserDatasource {
  @override
  Future<http.Response> getRandomUser() async {
    try {
      // Monta a URL da API
      final url = Uri.parse("https://randomuser.me/api/");
      // Realiza requisição GET
      final response = await http.get(url);
      return response;
    } on SocketException {
      // Erro de rede (sem conexão)
      throw UserErrorApiConnection();
    } catch (e) {
      // Erro genérico
      throw UserErrorGeneric("Erro inesperado ao buscar usuário: $e");
    }
  }
}
