import 'package:flutter/material.dart';

import '../../../components/components.dart';

class ObservationsAndInstructionsFields extends StatelessWidget {
  final TextEditingController observationsController;
  final TextEditingController instructionsController;
  const ObservationsAndInstructionsFields({
    required this.observationsController,
    required this.instructionsController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            decoration: FormFieldDecoration.decoration(
              isLoading: false,
              context: context,
              labelText: "Observações do pedido",
              hintText: "Observações do pedido",
            ),
            style: FormFieldStyle.style(),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: FormFieldDecoration.decoration(
              isLoading: false,
              context: context,
              labelText: "Instruções do pedido",
              hintText: "Instruções do pedido",
            ),
            style: FormFieldStyle.style(),
          ),
        ],
      ),
    );
  }
}
