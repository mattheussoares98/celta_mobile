import 'package:flutter/material.dart';

class ConfirmAdjustPriceButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Function() confirmAdjust;
  const ConfirmAdjustPriceButton({
    required this.formKey,
    required this.confirmAdjust,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await confirmAdjust();
      },
      child: const Text("Confirmar ajuste"),
    );
  }
}
