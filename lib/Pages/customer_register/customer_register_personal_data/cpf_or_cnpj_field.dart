import 'package:flutter/material.dart';

import '../../../components/components.dart';

class CpfOrCnpjField extends StatelessWidget {
  final FocusNode cpfCnpjFocusNode;
  final FocusNode nameFocusNode;
  final void Function(String) updateCpfCnpjEnabled;
  final void Function(bool) changeCpfCnpjIsValid;
  final TextEditingController cpfCnpjController;
  const CpfOrCnpjField({
    required this.cpfCnpjFocusNode,
    required this.nameFocusNode,
    required this.changeCpfCnpjIsValid,
    required this.updateCpfCnpjEnabled,
    required this.cpfCnpjController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FormFieldWidget(
      focusNode: cpfCnpjFocusNode,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      enabled: true,
      onChanged: (value) {
        updateCpfCnpjEnabled(value);
        bool isValid = FormFieldValidations.cpfOrCnpj(value) == null;
        if (isValid) {
          changeCpfCnpjIsValid(true);
        } else {
          changeCpfCnpjIsValid(false);
        }
      },
      suffixWidget: IconButton(
        onPressed: () {
          cpfCnpjController.text = "";
          FocusScope.of(context).requestFocus(cpfCnpjFocusNode);
        },
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
      onFieldSubmitted: (String? value) {
        nameFocusNode.requestFocus();
      },
      labelText: "CPF/CNPJ",
      validator: FormFieldValidations.cpfOrCnpj,
      textEditingController: cpfCnpjController,
      limitOfCaracters: 14,
    );
  }
}
