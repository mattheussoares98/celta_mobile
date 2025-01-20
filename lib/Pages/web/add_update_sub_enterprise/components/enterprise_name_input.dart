import 'package:flutter/material.dart';

import '../../../../components/components.dart';

class EnterpriseNameInput extends StatelessWidget {
  final TextEditingController enterpriseController;
  final FocusNode enterpriseFocusNode;
  final FocusNode ccsFocusNode;
  const EnterpriseNameInput({
    required this.enterpriseController,
    required this.enterpriseFocusNode,
    required this.ccsFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        autofocus: true,
        controller: enterpriseController,
        focusNode: enterpriseFocusNode,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Por favor, insira o nome da empresa";
          } else if (value.length < 3) {
            return "O nome da empresa deve ter no mínimo 3 caracteres";
          }
          return null;
        },
        onFieldSubmitted: (value) {
          if (value.isEmpty) {
            Future.delayed(Duration.zero, () {
              enterpriseFocusNode.requestFocus();
            });
          } else {
            ccsFocusNode.requestFocus();
          }
        },
        decoration: FormFieldDecoration.decoration(
          context: context,
          hintText: "Nome da empresa",
          labelText: "Nome da empresa",
        ),
      ),
    );
  }
}
