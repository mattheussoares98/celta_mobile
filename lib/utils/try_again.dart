import 'package:flutter/material.dart';

class TryAgainWidget {
  static Widget tryAgain({
    required String errorMessage,
    required Function request,
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
        TextButton(
          onPressed: () {
            request();
          },
          child: const Text('Tentar novamente'),
        ),
      ],
    );
  }
}
