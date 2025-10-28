import 'package:http/http.dart' as http;

/// Interface para datasource que busca usuário na API Random User
abstract class GetRandomUserDatasource {
  Future<http.Response> getRandomUser();
}
