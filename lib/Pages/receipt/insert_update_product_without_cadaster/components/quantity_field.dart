import 'package:flutter/material.dart';

import '../../../../components/components.dart';

class QuantityField extends StatelessWidget {
  final TextEditingController quantityController;
  final FocusNode quantityFocusNode;
  final Future<void> Function() insertUpdateProduct;
  const QuantityField({
    required this.quantityController,
    required this.quantityFocusNode,
    required this.insertUpdateProduct,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: quantityController,
      focusNode: quantityFocusNode,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: FormFieldDecoration.decoration(
        context: context,
        hintText: "Quantidade",
        labelText: "Quantidade",
        prefixIcon: IconButton(
          onPressed: () {
            quantityController.clear();
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ),
      onFieldSubmitted: (_) async {
        await insertUpdateProduct();
      },
      validator: FormFieldValidations.number,
    );
  }
}
