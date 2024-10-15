import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../providers/providers.dart';

class CpfOrCnpjField extends StatelessWidget {
  final FocusNode cpfCnpjFocusNode;
  final FocusNode reducedNameFocusNode;
  final void Function() updateCpfCnpjEnabled;
  final void Function() validateFormKey;
  const CpfOrCnpjField({
    required this.cpfCnpjFocusNode,
    required this.reducedNameFocusNode,
    required this.updateCpfCnpjEnabled,
    required this.validateFormKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CustomerRegisterProvider customerRegisterProvider = Provider.of(context);

    return FormFieldWidget(
      focusNode: cpfCnpjFocusNode,
      keyboardType: TextInputType.number,
      enabled: true,
      onChanged: (value) {
        updateCpfCnpjEnabled();
        validateFormKey();
      },
      suffixWidget: IconButton(
        onPressed: () {
          customerRegisterProvider.cpfCnpjController.text = "";
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
      textEditingController: customerRegisterProvider.cpfCnpjController,
      limitOfCaracters: 14,
    );
  }
}
