import 'package:flutter/material.dart';

import '../../../../components/product/product.dart';
import '../../../../models/soap/soap.dart';

class ShowCosts extends StatelessWidget {
  final GetProductJsonModel product;
  const ShowCosts({
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
                  content: Costs(product: product),
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
            "Visualizar custos",
          ),
        ),
      ],
    );
  }
}
