import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../../providers/providers.dart';

class ConfirmAdjustPriceButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  const ConfirmAdjustPriceButton({
    required this.formKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // AdjustSalePriceProvider adjustSalePriceProvider = Provider.of(context);

    return ElevatedButton(
      onPressed: () async {
        // bool? isValid = formKey.currentState?.validate();
      },
      child: const Text("Confirmar ajuste"),
    );
  }
}
