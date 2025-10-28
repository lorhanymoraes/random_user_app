import 'package:random_user_app/domain/utils/utils.dart';

/// Model que representa um usuário do Random User API
/// Contém todos os campos relevantes para exibição e persistência
class User {
  // Informações básicas
  final String gender;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String cell;
  final String picture;

  // ID do usuário
  final String idName;
  final String idValue;

  // Datas de nascimento e registro
  final String dobDate;
  final int dobAge;
  final String registeredDate;
  final int registeredAge;

  // Localização
  final int streetNumber;
  final String streetName;
  final String city;
  final String state;
  final String country;
  final dynamic postcode;
  final String latitude;
  final String longitude;
  final String timezoneOffset;
  final String timezoneDescription;

  // Nacionalidade
  final String nat;

  /// Construtor do usuário
  User({
    required this.gender,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.cell,
    required this.picture,
    required this.idName,
    required this.idValue,
    required this.dobDate,
    required this.dobAge,
    required this.registeredDate,
    required this.registeredAge,
    required this.streetNumber,
    required this.streetName,
    required this.city,
    required this.state,
    required this.country,
    required this.postcode,
    required this.latitude,
    required this.longitude,
    required this.timezoneOffset,
    required this.timezoneDescription,
    required this.nat,
  });

  /// Cria um usuário a partir de um Map (JSON)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      gender: json['gender'] ?? '',
      firstName: json['name']['first'] ?? '',
      lastName: json['name']['last'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      cell: json['cell'] ?? '',
      picture: json['picture']['large'] ?? '',

      idName: json['id']['name'] ?? '',
      idValue: json['id']['value'] ?? '',
      dobDate: json['dob']['date'] ?? '',
      dobAge: json['dob']['age'] ?? 0,
      registeredDate: json['registered']['date'] ?? '',
      registeredAge: json['registered']['age'] ?? 0,
      streetNumber: json['location']['street']['number'] ?? 0,
      streetName: json['location']['street']['name'] ?? '',
      city: json['location']['city'] ?? '',
      state: json['location']['state'] ?? '',
      country: json['location']['country'] ?? '',
      postcode: json['location']['postcode'] ?? '',
      latitude: json['location']['coordinates']['latitude'] ?? '',
      longitude: json['location']['coordinates']['longitude'] ?? '',
      timezoneOffset: json['location']['timezone']['offset'] ?? '',
      timezoneDescription: json['location']['timezone']['description'] ?? '',
      nat: json['nat'] ?? '',
    );
  }

  /// Converte o usuário para Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'name': {'first': firstName, 'last': lastName},
      'email': email,
      'phone': phone,
      'cell': cell,
      'picture': {'large': picture},
      'id': {'name': idName, 'value': idValue},
      'dob': {'date': dobDate, 'age': dobAge},
      'registered': {'date': registeredDate, 'age': registeredAge},
      'location': {
        'street': {'number': streetNumber, 'name': streetName},
        'city': city,
        'state': state,
        'country': country,
        'postcode': postcode,
        'coordinates': {'latitude': latitude, 'longitude': longitude},
        'timezone': {
          'offset': timezoneOffset,
          'description': timezoneDescription,
        },
      },
      'nat': nat,
    };
  }

  /// Retorna um Map agrupado para exibição na tela de detalhes
  /// Facilita a renderização dos dados organizados por categoria
  Map<String, dynamic> groupedDetails() {
    return {
      "Informações Básicas": {
        "Nome completo": "$firstName $lastName",
        "Gênero": gender,
        "Email": email,
        "Telefone": phone,
        "Celular": cell,
      },
      "ID": {"Nome": idName, "Valor": idValue},
      "Datas": {
        "Data de nascimento": formatIsoDateTime(dobDate),
        "Idade": dobAge,
        "Data de registro": formatIsoDateTime(registeredDate),
        "Anos desde registro": registeredAge,
      },
      "Localização": {
        "Rua": "$streetNumber $streetName",
        "Cidade": city,
        "Estado": state,
        "País": country,
        "CEP": postcode,
        "Coordenadas": "Lat: $latitude, Lng: $longitude",
        "Fuso horário": "$timezoneOffset - $timezoneDescription",
      },
      "Nacionalidade": {"NAT": nat},
    };
  }
}
