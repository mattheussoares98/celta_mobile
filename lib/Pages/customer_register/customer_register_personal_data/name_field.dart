import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../providers/providers.dart';

class NameField extends StatelessWidget {
  final FocusNode nameFocusNode;
  final FocusNode cpfCnpjFocusNode;
  final void Function() validateFormKey;
  const NameField({
    required this.nameFocusNode,
    required this.cpfCnpjFocusNode,
    required this.validateFormKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CustomerRegisterProvider customerRegisterProvider = Provider.of(context);

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
          customerRegisterProvider.nameController.text = "";
          FocusScope.of(context).requestFocus(nameFocusNode);
        },
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
      labelText: "Nome",
      validator: FormFieldValidations.nameAndLastName,
      textEditingController: customerRegisterProvider.nameController,
      limitOfCaracters: 50,
    );
  }
}
