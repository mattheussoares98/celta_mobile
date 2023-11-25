import 'package:flutter/material.dart';

class ShowSnackbarMessage {
  static showMessage({
    required String message,
    required BuildContext context,
    String labelSnackBarAction = "",
    Function? functionSnackBarAction,
    Color backgroundColor = Colors.red,
    int? secondsDuration = 5,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
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
                  backgroundColor: Colors.amberAccent,
                ),
                onPressed: () => {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                  functionSnackBarAction(),
                },
                child: Text(
                  labelSnackBarAction,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: secondsDuration!),
      ),
    );
  }
}
