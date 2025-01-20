import 'package:flutter/material.dart';

import '../../../../components/components.dart';

class CcsUrlInput extends StatelessWidget {
  final TextEditingController urlCcsController;
  final FocusNode ccsFocusNode;
  final FocusNode cnpjFocusNode;
  const CcsUrlInput({
    required this.urlCcsController,
    required this.ccsFocusNode,
    required this.cnpjFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: urlCcsController,
        focusNode: ccsFocusNode,
        onFieldSubmitted: (value) {
          if (value.isEmpty) {
            Future.delayed(Duration.zero, () {
              ccsFocusNode.requestFocus();
            });
          } else {
            cnpjFocusNode.requestFocus();
          }
        },
        validator: (value) {
          if (value == null ||
              !value.toLowerCase().contains("http") ||
              !value.contains(":") ||
              !value.contains("//") ||
              !value.contains("\.") ||
              !value.toLowerCase().contains("ccs")) {
            return "URL inválida";
          }
          return null;
        },
        decoration: FormFieldDecoration.decoration(
          context: context,
          hintText: "http://127.0.0.1:9092/ccs",
          labelText: "Url do CCS",
        ),
      ),
    );
  }
}
