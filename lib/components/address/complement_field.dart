import 'package:flutter/material.dart';

import '../components.dart';

class ComplementField extends StatelessWidget {
  final TextEditingController complementController;
  final FocusNode complementFocusNode;
  final FocusNode referenceFocusNode;
  const ComplementField({
    super.key,
    required this.complementController,
    required this.complementFocusNode,
    required this.referenceFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return FormFieldWidget(
      enabled: true,
      focusNode: complementFocusNode,
      onFieldSubmitted: (_) {
        referenceFocusNode.requestFocus();
      },
      labelText: "Complemento",
      textEditingController: complementController,
      limitOfCaracters: 30,
    );
  }
}
