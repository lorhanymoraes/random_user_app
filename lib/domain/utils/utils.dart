import 'package:intl/intl.dart';

/// Formata uma string de data no formato ISO para "dd/MM/yyyy HH:mm"
/// Usado para exibir datas de forma amigável na interface
String formatIsoDateTime(String isoDateTime) {
  try {
    final date = DateTime.parse(isoDateTime);
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  } catch (_) {
    return isoDateTime; // fallback caso a string esteja inválida
  }
}
