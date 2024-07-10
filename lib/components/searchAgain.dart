import 'package:flutter/material.dart';

Widget searchAgain({
  required String errorMessage,
  required Function request,
  String message = "Consultar novamente",
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      FittedBox(
        child: TextButton(
          onPressed: () async {
            await request();
          },
          child: Row(
            children: [
              Text(message),
              const SizedBox(width: 10),
              const Icon(Icons.refresh),
            ],
          ),
        ),
      ),
    ],
  );
}
