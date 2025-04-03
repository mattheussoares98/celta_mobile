import 'package:flutter/material.dart';

import '../components.dart';

class ReferenceField extends StatelessWidget {
  final bool isLoading;
  final FocusNode referenceFocusNode;
  final TextEditingController referenceController;
  const ReferenceField({
    super.key,
    required this.isLoading,
    required this.referenceFocusNode,
    required this.referenceController,
  });

  @override
  Widget build(BuildContext context) {
    return FormFieldWidget(
      enabled: isLoading,
      focusNode: referenceFocusNode,
      labelText: "Referência",
      textEditingController: referenceController,
      limitOfCaracters: 40,
    );
  }
}
