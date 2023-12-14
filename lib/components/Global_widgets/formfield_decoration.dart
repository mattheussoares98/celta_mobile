import 'package:flutter/material.dart';

class FormFieldHelper {
  static InputDecoration decoration({
    required bool isLoading,
    required BuildContext context,
    required String labelText,
    double? hintSize = 17,
    double? labelSize = 15,
    double? errorSize = 12,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintStyle: TextStyle(
        fontSize: hintSize,
        color: Colors.grey,
      ),
      labelStyle: TextStyle(
        fontSize: labelSize,
        color: isLoading ? Colors.grey : Theme.of(context).primaryColor,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
      ),
      floatingLabelStyle: TextStyle(
        color: isLoading ? Colors.grey : Theme.of(context).primaryColor,
        fontWeight: FontWeight.normal,
      ),
      errorStyle: TextStyle(
        fontSize: errorSize,
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          style: BorderStyle.solid,
          width: 1,
          color: Colors.grey,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          style: BorderStyle.solid,
          width: 1,
          color: Colors.grey,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          style: BorderStyle.solid,
          width: 1,
          color: Theme.of(context).colorScheme.error,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          style: BorderStyle.solid,
          width: 1,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          style: BorderStyle.solid,
          width: 1,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      hintText: hintText,
    );
  }

  static TextStyle style() {
    return const TextStyle(
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.normal,
    );
  }

  static String? Function(String?)? validatorOfNumber(
      {int maxDecimalPlaces = 2}) {
    return (value) {
      if (value!.isEmpty) {
        return 'Digite uma quantidade';
      } else if (value == '0' || value == '0.' || value == '0,') {
        return 'Digite uma quantidade';
      } else if (value.contains('.') && value.contains(',')) {
        return 'Carácter inválido';
      } else if (value.contains('-')) {
        return 'Carácter inválido';
      } else if (value.contains(' ')) {
        return 'Carácter inválido';
      } else if (value.characters
              .toList()
              .fold<int>(0, (t, e) => e == "." ? t + e.length : t + 0) >
          1) {
        // verifica se tem mais de um ponto
        return 'Carácter inválido';
      } else if (value.characters
              .toList()
              .fold<int>(0, (t, e) => e == "," ? t + e.length : t + 0) >
          1) {
        // verifica se tem mais de uma vírgula
        return 'Carácter inválido';
      } else if (double.tryParse(value.replaceAll(RegExp(r','), '.')) == 0 ||
          double.tryParse(value.replaceAll(RegExp(r','), '.')) == null) {
        return "Digite uma quantidade";
      }

      // Adiciona a verificação do número máximo de casas decimais
      List<String> parts = value.replaceAll(RegExp(r'\,'), '.').split('.');
      if (parts.length > 1 && parts[1].length > maxDecimalPlaces) {
        return '$maxDecimalPlaces casas decimais';
      }

      return null;
    };
  }
}
