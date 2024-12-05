import 'package:flutter/material.dart';

import '../../../../components/components.dart';
import '../../../../utils/utils.dart';

class EanField extends StatelessWidget {
  final TextEditingController eanController;
  final FocusNode observationsFocusNode;
  const EanField({
    required this.eanController,
    required this.observationsFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: eanController,
      keyboardType: const TextInputType.numberWithOptions(),
      decoration: FormFieldDecoration.decoration(
        isLoading: false,
        context: context,
        hintText: "EAN",
        labelText: "EAN",
        suffixIcon: IconButton(
          onPressed: () async {
            eanController.text = await ScanBarCode.scanBarcode(context);
          },
          icon: Icon(
            Icons.camera_alt,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        prefixIcon: IconButton(
          onPressed: () {
            eanController.clear();
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ),
      onFieldSubmitted: (_) {
        observationsFocusNode.requestFocus();
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Digite o EAN!";
        } else if (value.length < 4) {
          return "EAN inválido";
        } else if (int.tryParse(value) == null) {
          return "EAN inválido";
        } else {
          return null;
        }
      },
    );
  }
}
