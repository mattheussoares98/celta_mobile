import 'package:flutter/material.dart';

import '../../../components/components.dart';

class ReducedNameField extends StatelessWidget {
  final FocusNode reducedNameFocusNode;
  final FocusNode dateOfBirthFocusNode;
  final void Function() validateFormKey;
  final TextEditingController reducedNameController;
  final bool cpfCnpjIsValid;
  const ReducedNameField({
    required this.reducedNameFocusNode,
    required this.dateOfBirthFocusNode,
    required this.validateFormKey,
    required this.reducedNameController,
    required this.cpfCnpjIsValid,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FormFieldWidget(
      enabled: cpfCnpjIsValid,
      focusNode: reducedNameFocusNode,
      onChanged: (_) {
        validateFormKey();
      },
      suffixWidget: IconButton(
        onPressed: () {
          reducedNameController.text = "";
          FocusScope.of(context).requestFocus(reducedNameFocusNode);
        },
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
      onFieldSubmitted: (String? value) {
        FocusScope.of(context).requestFocus(dateOfBirthFocusNode);
      },
      labelText: "Nome reduzido",
      textEditingController: reducedNameController,
      limitOfCaracters: 25,
    );
  }
}
