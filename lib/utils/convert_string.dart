import 'package:intl/intl.dart';

class ConvertString {
  static String convertToBRL(dynamic value) {
    value = value.toString();

    if (value.toString().contains(",")) {
      value = value = value.toString().replaceAll(RegExp(r','), '.');
    }

    int pointQuantity = ".".allMatches(value).length;
    for (var x = 1; x < pointQuantity; x++) {
      if (x < pointQuantity && pointQuantity > 1) {
        value = value.toString().replaceFirst(RegExp(r'\.'), '');
      }
    }

    value = double.tryParse(value.toString())!;

    final formatter = new NumberFormat("#,##0.00", "pt_BR");
    String newText = formatter.format(value) + "R\$";

    return newText;
  }

  static String convertToBrazilianNumber(
    dynamic value, {
    int? decimalHouses = 3,
  }) {
    value = value.toString();

    if (value.toString().contains(",")) {
      value = value = value.toString().replaceAll(RegExp(r','), '.');
    }

    int pointQuantity = ".".allMatches(value).length;
    for (var x = 1; x < pointQuantity; x++) {
      if (x < pointQuantity && pointQuantity > 1) {
        value = value.toString().replaceFirst(RegExp(r'\.'), '');
      }
    }

    value = double.tryParse(value.toString())!;

    NumberFormat formatter = new NumberFormat("#,##0.000", "pt_BR");

    if (decimalHouses == 1) {
      formatter = new NumberFormat("#,##0.0", "pt_BR");
    } else if (decimalHouses == 2) {
      formatter = new NumberFormat("#,##0.00", "pt_BR");
    }

    String newText = formatter.format(value);

    return newText;
  }

  static bool isUrl(String text) {
    return text.toLowerCase().contains('http') &&
        text.toLowerCase().contains('//') &&
        text.toLowerCase().contains(':') &&
        text.toLowerCase().contains('ccs');
  }

  // static String convertToRemoveSpecialCaracters(dynamic value) {
  //deixar comentado pra se precisar usar futuramente
  //   value = value.toString();

  //   value = value.toString().replaceAll(RegExp(r':'), '%3A');
  //   value = value.toString().replaceAll(RegExp(r' '), '%20');
  //   value = value.toString().replaceAll(RegExp(r'!'), '%21');
  //   value = value.toString().replaceAll(RegExp(r'#'), '%23');
  //   value = value.toString().replaceAll(RegExp(r'\$'), '%24');
  //   value = value.toString().replaceAll(RegExp(r'&'), '%26');
  //   value = value.toString().replaceAll(RegExp(r"\\'"), '%27');
  //   value = value.toString().replaceAll(RegExp(r'\('), '%28');
  //   value = value.toString().replaceAll(RegExp(r'\)'), '%29');
  //   value = value.toString().replaceAll(RegExp(r'\*'), '%2A');
  //   value = value.toString().replaceAll(RegExp(r'\+'), '%2B');
  //   value = value.toString().replaceAll(RegExp(r','), '%2C');
  //   value = value.toString().replaceAll(RegExp(r'/'), '%2F');
  //   value = value.toString().replaceAll(RegExp(r';'), '%3B');
  //   value = value.toString().replaceAll(RegExp(r'='), '%3D');
  //   value = value.toString().replaceAll(RegExp(r'\?'), '%3F');
  //   value = value.toString().replaceAll(RegExp(r'\@'), '%40');
  //   value = value.toString().replaceAll(RegExp(r'\['), '%5B');
  //   value = value.toString().replaceAll(RegExp(r'\\'), '%5C');
  //   value = value.toString().replaceAll(RegExp(r']'), '%5D');
  //   value = value.toString().replaceAll(RegExp(r'\^'), '%5E');
  //   value = value.toString().replaceAll(RegExp(r'_'), '%5F');
  //   value = value.toString().replaceAll(RegExp(r'`'), '%60');
  //   value = value.toString().replaceAll(RegExp(r'{'), '%7B');
  //   value = value.toString().replaceAll(RegExp(r'\|'), '%7C');
  //   value = value.toString().replaceAll(RegExp(r'}'), '%7D');
  //   value = value.toString().replaceAll(RegExp(r'~'), '%7E');
  //   value = value.toString().replaceAll(RegExp(r'\%'), '%25');

  //   return value;
  // }
}
