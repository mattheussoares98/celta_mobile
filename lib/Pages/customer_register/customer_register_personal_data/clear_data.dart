import 'package:flutter/material.dart';

import '../../../components/components.dart';

class ClearData extends StatelessWidget {
  final void Function()? clearControllers;
  const ClearData({
    required this.clearControllers,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        onPressed: clearControllers == null
            ? null
            : () {
                ShowAlertDialog.show(
                  context: context,
                  title: "Limpar dados",
                  content: const SingleChildScrollView(
                    child: Text(
                      "Deseja realmente limpar todos dados pessoais digitados?",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  function: clearControllers!,
                );
              },
        child: const Text("Limpar dados"),
      ),
    );
  }
}
