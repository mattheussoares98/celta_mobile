import 'package:flutter/material.dart';

import '../../../components/components.dart';

class CpfOrCnpjField extends StatelessWidget {
  final FocusNode cpfCnpjFocusNode;
  final FocusNode reducedNameFocusNode;
  final void Function() updateCpfCnpjEnabled;
  final void Function() validateFormKey;
  final TextEditingController cpfCnpjController;
  const CpfOrCnpjField({
    required this.cpfCnpjFocusNode,
    required this.reducedNameFocusNode,
    required this.updateCpfCnpjEnabled,
    required this.validateFormKey,
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
        updateCpfCnpjEnabled();
        validateFormKey();
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
        FocusScope.of(context).requestFocus(reducedNameFocusNode);
      },
      labelText: "CPF/CNPJ",
      validator: FormFieldValidations.cpfOrCnpj,
      textEditingController: cpfCnpjController,
      limitOfCaracters: 14,
    );
  }
}
