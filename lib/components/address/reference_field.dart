import 'package:flutter/material.dart';

import '../components.dart';

class ReferenceField extends StatelessWidget {
  final FocusNode referenceFocusNode;
  final TextEditingController referenceController;
  const ReferenceField({
    super.key,
    required this.referenceFocusNode,
    required this.referenceController,
  });

  @override
  Widget build(BuildContext context) {
    return FormFieldWidget(
      enabled: true,
      focusNode: referenceFocusNode,
      labelText: "Referência",
      textEditingController: referenceController,
      limitOfCaracters: 40,
    );
  }
}
