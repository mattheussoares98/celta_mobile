import 'package:flutter/material.dart';

import '../components.dart';

class DistrictField extends StatelessWidget {
  final TextEditingController cepController;
  final TextEditingController districtController;
  final bool isLoading;
  final FocusNode districtFocusNode;
  final FocusNode cityFocusNode;
  const DistrictField({
    super.key,
    required this.cepController,
    required this.districtController,
    required this.isLoading,
    required this.districtFocusNode,
    required this.cityFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return FormFieldWidget(
      enabled: isLoading == false,
      focusNode: districtFocusNode,
      onFieldSubmitted: (String? value) {
        FocusScope.of(context).requestFocus(cityFocusNode);
      },
      labelText: "Bairro",
      textEditingController: districtController,
      limitOfCaracters: 30,
      validator: (String? value) {
        if ((value == null || value.isEmpty || value.length < 2) &&
            cepController.text.length == 8) {
          return "Bairro muito curto";
        }
        return null;
      },
    );
  }
}
