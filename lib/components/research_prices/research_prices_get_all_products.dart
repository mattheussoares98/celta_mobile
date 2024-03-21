import 'package:flutter/material.dart';

TextButton getAllProductsButton({
  required Function getProducts,
  required String typeOfFilterSearch,
}) {
  return TextButton(
    onPressed: () async {
      await getProducts();
    },
    child: FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(typeOfFilterSearch),
          const SizedBox(width: 10),
          const Icon(Icons.refresh),
        ],
      ),
    ),
  );
}
