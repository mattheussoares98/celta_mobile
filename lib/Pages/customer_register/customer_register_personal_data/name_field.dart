import 'package:flutter/material.dart';

import '../../../components/components.dart';

class NameField extends StatelessWidget {
  final FocusNode nameFocusNode;
  final FocusNode cpfCnpjFocusNode;
  final void Function() validateFormKey;
  final TextEditingController nameController;
  const NameField({
    required this.nameFocusNode,
    required this.cpfCnpjFocusNode,
    required this.validateFormKey,
    required this.nameController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FormFieldWidget(
      enabled: true,
      focusNode: nameFocusNode,
      onChanged: (_) {
        validateFormKey();
      },
      onFieldSubmitted: (String? value) {
        FocusScope.of(context).requestFocus(cpfCnpjFocusNode);
      },
      suffixWidget: IconButton(
        onPressed: () {
          nameController.text = "";
          FocusScope.of(context).requestFocus(nameFocusNode);
        },
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
      labelText: "Nome",
      validator: FormFieldValidations.nameAndLastName,
      textEditingController: nameController,
      limitOfCaracters: 50,
    );
  }
}
