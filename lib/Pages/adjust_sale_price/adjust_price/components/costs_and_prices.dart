import 'package:flutter/material.dart';

import '../../../../components/product/product.dart';
import '../../../../models/soap/soap.dart';
import '../../../../components/product/more_informations/prices.dart';

class CostsAndPrices extends StatelessWidget {
  final GetProductJsonModel product;
  const CostsAndPrices({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Column(
                    children: [
                      Costs(product: product),
                      const Divider(),
                      Prices(product: product)
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Fechar"),
                    ),
                  ],
                );
              },
            );
          },
          child: const Text(
            "Custos e preços",
          ),
        ),
      ],
    );
  }
}
