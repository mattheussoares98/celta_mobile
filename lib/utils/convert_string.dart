class ConvertString {
  static String convertToBRL(dynamic value) {
    value = value.toString();

    if (value.toString().contains(",")) {
      value = value.toString().replaceAll(RegExp(r','), '.');
    }

    value = double.tryParse(value)!
            .toStringAsFixed(2)
            .toString()
            .replaceAll(RegExp(r'\.'), ',') +
        " R\$";

    return value;
  }
}
