import 'package:flutter/material.dart';

import '../../../../components/components.dart';

class ObservationsField extends StatelessWidget {
  final TextEditingController observationsController;
  final FocusNode observationsFocusNode;
  final FocusNode quantityFocusNode;
  const ObservationsField({
    required this.observationsController,
    required this.observationsFocusNode,
    required this.quantityFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: observationsFocusNode,
      controller: observationsController,
      onFieldSubmitted: (_) {
        quantityFocusNode.requestFocus();
      },
      decoration: FormFieldDecoration.decoration(
        isLoading: false,
        context: context,
        hintText: "Observações",
        labelText: "Observações",
        prefixIcon: IconButton(
          onPressed: () {
            observationsController.clear();
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
