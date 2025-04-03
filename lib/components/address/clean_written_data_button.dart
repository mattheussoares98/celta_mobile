import 'package:flutter/material.dart';

import '../components.dart';

class CleanWrittenDataButton extends StatelessWidget {
  final void Function() clearControllers;
  const CleanWrittenDataButton({
    super.key,
    required this.clearControllers,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(backgroundColor: Colors.red),
      onPressed: () {
        ShowAlertDialog.show(
          context: context,
          title: "Apagar dados digitados",
          content: const SingleChildScrollView(
            child: Text(
              "Deseja apagar todos os dados preenchidos?",
              textAlign: TextAlign.center,
            ),
          ),
          function: clearControllers,
        );
      },
      child: const Text(
        "Apagar dados",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
