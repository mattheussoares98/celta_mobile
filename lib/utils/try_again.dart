import 'package:flutter/material.dart';
import 'error_message.dart';

class TryAgainWidget {
  static Widget tryAgain({
    required String errorMessage,
    required Function request,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ErrorMessage(text: errorMessage),
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
