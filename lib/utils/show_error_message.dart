import 'package:flutter/material.dart';

class ShowErrorMessage {
  static showErrorMessage({
    required String error,
    required BuildContext context,
    //sempre que cai no catch das requisições http é porque não encontrou o
    //servidor. Nesse caso pode exibir uma mensagem padrão
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
