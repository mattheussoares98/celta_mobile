import 'package:flutter/material.dart';

class ShowAlertDialog {
  static show({
    required BuildContext context,
    required String title,
    required Function() function,
    Widget? content,
    double? titleSize = 25,
    double? subtitleSize = 20,
    String? confirmMessage = "SIM",
    String? cancelMessage = "NÃO",
    double? confirmMessageSize = 40,
    double? cancelMessageSize = 40,
    bool? showConfirmAndCancelMessage = true,
    bool? canCloseClickingOut = true,
    bool? showCloseAlertDialogButton = false,
    Widget? otherWidgetAction,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsets? insetPadding,
  }) {
    showDialog(
      context: context,
      barrierDismissible: canCloseClickingOut == true,
      builder: (context) {
        return AlertDialog(
          insetPadding: insetPadding,
          contentPadding: contentPadding,
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: titleSize,
              fontFamily: "BebasNeue",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: content,
          actionsPadding: const EdgeInsets.all(10),
          actions: [
            if (showConfirmAndCancelMessage == true)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(60, 60),
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: FittedBox(
                        child: Text(
                          cancelMessage!,
                          style: TextStyle(
                            fontSize: cancelMessageSize,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(60, 60),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        function();
                      },
                      child: FittedBox(
                        child: Text(
                          confirmMessage!,
                          style: TextStyle(
                            fontSize: confirmMessageSize,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            if (showCloseAlertDialogButton == true)
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Fechar",
                    style: TextStyle(fontSize: subtitleSize),
                  ),
                ),
              ),
            if (otherWidgetAction != null) otherWidgetAction,
          ],
        );
      },
    );
  }
}
