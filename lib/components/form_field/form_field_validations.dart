import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';

class FormFieldValidations {
  FormFieldValidations._();

  static String? number({
    String? value,
    int maxDecimalPlaces = 3,
    bool valueCanIsEmpty = false,
  }) {
    if (value!.isEmpty && !valueCanIsEmpty) {
      return 'Digite um valor';
    } else if (value == '0' || value == '0.' || value == '0,') {
      return 'Digite um valor';
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
    } else if (double.tryParse(value.replaceAll(RegExp(r','), '.')) == null &&
        value.isNotEmpty &&
        !valueCanIsEmpty) {
      return "Digite um valor";
    } else if (double.tryParse(value.replaceAll(RegExp(r','), '.')) == null &&
        value.isNotEmpty) {
      return "Número inválido";
    }

    // Adiciona a verificação do número máximo de casas decimais
    List<String> parts = value.replaceAll(RegExp(r'\,'), '.').split('.');
    if (parts.length > 1 && parts[1].length > maxDecimalPlaces) {
      return '$maxDecimalPlaces casas decimais';
    }

    return null;
  }

  static String? cpf(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    } else if (value.length < 8) {
      return "Quantidade de números inválido!";
    } else if (value.contains("\.") ||
        value.contains("\,") ||
        value.contains("\-") ||
        value.contains(" ")) {
      return "Digite somente números";
    }
    return null;
  }

  static String? nameAndLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'O nome é obrigatório';
    } else {
      List<String> nameParts = value.split(' ');

      if (nameParts.length < 2) {
        return 'Informe o nome e o sobrenome';
      }

      if (nameParts[0].length < 3 || nameParts[1].length < 3) {
        return 'O nome e o sobrenome devem ter pelo menos 3 letras';
      }

      return null;
    }
  }

  static String? cpfOrCnpj(String? value) {
    if (value == null || value.isEmpty) {
      return "Informe o CPF ou CNPJ";
    } else if (value.contains(" ") ||
        value.contains("\.") ||
        value.contains(",") ||
        value.contains("-")) {
      return "Digite somente números!";
    } else if (value.length == 11 && CPFValidator.isValid(value)) {
      return null;
    } else if (value.length == 11 && !CPFValidator.isValid(value)) {
      return "CPF inválido!";
    } else if (value.length == 14 && CNPJValidator.isValid(value)) {
      return null;
    } else if (value.length == 14 && !CNPJValidator.isValid(value)) {
      return "CNPJ inválido!";
    } else if (value.length < 11) {
      return "Quantidade de caracteres inválido";
    } else if (value.length > 11 && value.length < 14) {
      return "Quantidade de caracteres inválido";
    }

    return "CPF/CNPJ inválido!";
  }

  static String? minimumSize({
    required String? value,
    required int minimumSize,
  }) {
    if (value == null || value.isEmpty || value.length < minimumSize) {
      return "Mínimo de $minimumSize caracteres";
    }
    return null;
  }
}
