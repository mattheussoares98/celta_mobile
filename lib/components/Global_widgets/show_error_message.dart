import 'package:flutter/material.dart';

class ShowErrorMessage {
  static showErrorMessage({
    required String error,
    required BuildContext context,
    //sempre que cai no catch das requisições http é porque não encontrou o
    //servidor. Nesse caso pode exibir uma mensagem padrão
    String labelSnackBarAction = "",
    Function? functionSnackBarAction,
    Color backgroundColor = Colors.red,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                error,
                textAlign: TextAlign.center,
              ),
            ),
            if (labelSnackBarAction != "" && functionSnackBarAction != null)
              TextButton(
                style: TextButton.styleFrom(
                  elevation: 10,
                  backgroundColor: Colors.amber,
                ),
                onPressed: () => {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                  functionSnackBarAction(),
                },
                child: Text(labelSnackBarAction),
              ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
