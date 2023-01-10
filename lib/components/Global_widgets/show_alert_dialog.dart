import 'package:flutter/material.dart';

class ShowAlertDialog {
  showAlertDialog({
    required BuildContext context,
    required String title,
    required Function() function,
    String? subtitle,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          content: subtitle == null
              ? null
              : Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.center,
                ),
          actionsPadding: const EdgeInsets.all(10),
          actions: [
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    onPressed: () {
                      function();
                      Navigator.of(context).pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(30),
                      child: Text(
                        'SIM',
                        style: TextStyle(
                          fontSize: 300,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 50),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        )),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(30),
                      child: Text(
                        'NÃO',
                        style: TextStyle(
                          fontSize: 300,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
