import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../providers/providers.dart';

class ReducedNameField extends StatelessWidget {
  final FocusNode reducedNameFocusNode;
  final FocusNode dateOfBirthFocusNode;
  final void Function() validateFormKey;
  const ReducedNameField({
    required this.reducedNameFocusNode,
    required this.dateOfBirthFocusNode,
    required this.validateFormKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CustomerRegisterProvider customerRegisterProvider = Provider.of(context);

    return FormFieldWidget(
      enabled: true,
      focusNode: reducedNameFocusNode,
      onChanged: (_) {
        validateFormKey();
      },
      suffixWidget: IconButton(
        onPressed: () {
          customerRegisterProvider.reducedNameController.text = "";
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
      textEditingController: customerRegisterProvider.reducedNameController,
      limitOfCaracters: 25,
    );
  }
}
