import 'package:flutter/material.dart';

import '../components.dart';

class NumberField extends StatelessWidget {
  final TextEditingController zipController;
  final TextEditingController numberController;
  final FocusNode numberFocusNode;
  final FocusNode complementFocusNode;
  const NumberField({
    super.key,
    required this.zipController,
    required this.numberController,
    required this.numberFocusNode,
    required this.complementFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return FormFieldWidget(
      enabled: true,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      focusNode: numberFocusNode,
      onFieldSubmitted: (String? value) async {
        complementFocusNode.requestFocus();
      },
      labelText: "Número",
      textEditingController: numberController,
      limitOfCaracters: 6,
      validator: (value) => FormFieldValidations.number(value, isInteger: true),
    );
  }
}
