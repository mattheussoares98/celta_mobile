import 'package:flutter/material.dart';

import '../../../../utils/utils.dart';

class ProductsWithoutCadasterButton extends StatelessWidget {
  final int docCode;
  const ProductsWithoutCadasterButton({
    required this.docCode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed(
          APPROUTES.RECEIPT_PRODUCTS_WITHOUT_CADASTER,
          arguments: docCode,
        );
      },
      child: const FittedBox(child: Text("Não encontrados")),
    );
  }
}
