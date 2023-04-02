import 'package:intl/intl.dart';

class ConvertString {
  static String convertToBRL(dynamic value) {
    value = value.toString();

    int pointQuantity = ".".allMatches(value).length;
    for (var x = 0; x < pointQuantity; x++) {
      if (x != pointQuantity) {
        value = value.toString().replaceFirst(RegExp(r'\.'), '');
      }
    }
    if (value.toString().contains(",")) {
      value = value.toString().replaceAll(RegExp(r','), '.');
    }

    if (value.toString().contains(",")) {
      value = value.toString().replaceAll(RegExp(r','), '.');
    }

    value = double.tryParse(value)!.toStringAsFixed(2);

    value = double.parse(value);
    final formatter = new NumberFormat("#,##0.00", "pt_BR");
    String newText = formatter.format(value) + " R\$";

    return newText;
  }

  static String convertToBrazilianNumber(dynamic value) {
    value = value.toString();

    int pointQuantity = ".".allMatches(value).length;
    for (var x = 0; x < pointQuantity; x++) {
      if (x < pointQuantity && pointQuantity > 1) {
        value = value.toString().replaceFirst(RegExp(r'\.'), '');
      }
    }
    if (value.toString().contains(",")) {
      value = value.toString().replaceAll(RegExp(r','), '.');
    }

    // value = double.tryParse(value)!.toStringAsFixed(3);

    value = double.parse(value);
    final formatter = new NumberFormat("#,##0.000", "pt_BR");
    String newText = formatter.format(value);

    return newText;
  }
}
