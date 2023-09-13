import 'package:flutter/material.dart';

class ShowSnackbarMessage {
  static showMessage({
    required String message,
    required BuildContext context,
    //sempre que cai no catch das requisições http é porque não encontrou o
    //servidor. Nesse caso pode exibir uma mensagem padrão
    String labelSnackBarAction = "",
    Function? functionSnackBarAction,
    Color backgroundColor = Colors.red,
    int? secondsDuration = 5,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                message,
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
        duration: Duration(seconds: secondsDuration!),
      ),
    );
  }
}
