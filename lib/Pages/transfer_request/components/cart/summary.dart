import 'package:flutter/material.dart';

import '../../../../models/models.dart';
import '../../../../utils/utils.dart';

class Summary extends StatelessWidget {
  final TransferRequestCartProductsModel product;
  const Summary({
    required this.product,
    super.key,
  });

  Widget item({
    required String title,
    required String value,
    required bool addBrazilianCoin,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey[600])),
          Text(
            "${value.toBrazilianNumber()}" +
                (addBrazilianCoin == true ? "".addBrazilianCoin() : ""),
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        item(
          title: "Qtd",
          value: product.Quantity.toString(),
          addBrazilianCoin: false,
        ),
        item(
          title: "Preço",
          value: product.Value.toString(),
          addBrazilianCoin: true,
        ),
        item(
          title: "Total",
          value: (product.Quantity * product.Value).toString(),
          addBrazilianCoin: true,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
        ),
      ],
    );
  }
}
