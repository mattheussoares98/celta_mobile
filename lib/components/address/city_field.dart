import 'package:flutter/material.dart';

import '../components.dart';

class CityField extends StatelessWidget {
  final TextEditingController cepController;
  final TextEditingController cityController;
  final bool isLoading;
  final FocusNode cityFocusNode;
  final FocusNode stateFocusNode;
  const CityField({
    super.key,
    required this.cepController,
    required this.cityController,
    required this.isLoading,
    required this.cityFocusNode,
    required this.stateFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FormFieldWidget(
        enabled: isLoading == false,
        focusNode: cityFocusNode,
        labelText: "Cidade",
        textEditingController: cityController,
        limitOfCaracters: 30,
        onFieldSubmitted: (value) {
          stateFocusNode.requestFocus();
        },
        validator: (String? value) {
          if ((value == null || value.isEmpty || value.length < 2) &&
              cepController.text.length == 8) {
            return "Cidade muito curta";
          }
          return null;
        },
      ),
    );
  }
}
