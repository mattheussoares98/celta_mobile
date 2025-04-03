import 'package:flutter/material.dart';

import '../components.dart';

class NumberField extends StatelessWidget {
  final TextEditingController cepController;
  final TextEditingController numberController;
  final bool isLoading;
  final FocusNode numberFocusNode;
  final FocusNode complementFocusNode;
  const NumberField({
    super.key,
    required this.cepController,
    required this.numberController,
    required this.isLoading,
    required this.numberFocusNode,
    required this.complementFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return FormFieldWidget(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      enabled: isLoading == false,
      focusNode: numberFocusNode,
      onFieldSubmitted: (String? value) async {
        complementFocusNode.requestFocus();
      },
      labelText: "Número",
      textEditingController: numberController,
      limitOfCaracters: 6,
      validator: (String? value) {
        if ((value == null || value.isEmpty || value.length < 1) &&
            cepController.text.length == 8) {
          return "Digite o número!";
        } else if (value!.contains("\.") ||
            value.contains("\,") ||
            value.contains("\-") ||
            value.contains(" ")) {
          return "Digite somente números";
        }
        return null;
      },
    );
  }
}
