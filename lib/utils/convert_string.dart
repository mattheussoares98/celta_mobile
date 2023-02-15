import 'package:intl/intl.dart';

class ConvertString {
  static String convertToBRL(dynamic value) {
    value = value.toString();

    if (value.toString().contains(",")) {
      value = value.toString().replaceAll(RegExp(r','), '.');
    }

    value = double.tryParse(value)!.toStringAsFixed(2);

    value = double.parse(value);
    final formatter = new NumberFormat("#,##0.00", "pt_BR");
    String newText = "R\$ " + formatter.format(value);

    return newText;
  }
}
