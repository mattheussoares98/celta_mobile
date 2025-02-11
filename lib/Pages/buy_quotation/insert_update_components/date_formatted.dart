import 'package:intl/intl.dart';

String? dateFormatted(String? value) {
  if (value == null) {
    return null;
  } else {
    final formattedDate = DateTime.parse(value);

    if (formattedDate.isBefore(DateTime(2000))) {
      return null;
    } else {
      return DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(value));
    }
  }
}
