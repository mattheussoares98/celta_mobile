import 'package:flutter/material.dart';

import '../components.dart';

class AddressField extends StatelessWidget {
  final TextEditingController cepController;
  final TextEditingController addressController;
  final FocusNode addressFocusNode;
  final bool isLoading;
  final FocusNode districtFocusNode;
  const AddressField({
    super.key,
    required this.cepController,
    required this.addressController,
    required this.isLoading,
    required this.districtFocusNode,
    required this.addressFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return FormFieldWidget(
      enabled: isLoading == false,
      focusNode: addressFocusNode,
      labelText: "Logradouro",
      textEditingController: addressController,
      limitOfCaracters: 40,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(districtFocusNode);
      },
      validator: (String? value) {
        if ((value == null || value.isEmpty || value.length < 5) &&
            cepController.text.length == 8) {
          return "Logradouro muito curto";
        }
        return null;
      },
    );
  }
}
