import 'package:flutter/material.dart';

import '../../../../models/models.dart';

class InsertButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final int docCode;
  final TextEditingController eanController;
  final TextEditingController observationsController;
  final TextEditingController quantityController;
  final bool isInserting;
  final ProductWithoutCadasterModel? product;
  final Future<void> Function() insertUpdateProduct;
  const InsertButton({
    required this.formKey,
    required this.docCode,
    required this.eanController,
    required this.observationsController,
    required this.quantityController,
    required this.isInserting,
    required this.product,
    required this.insertUpdateProduct,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: insertUpdateProduct,
      child: Text(isInserting ? "Inserir" : "Alterar"),
    );
  }
}
