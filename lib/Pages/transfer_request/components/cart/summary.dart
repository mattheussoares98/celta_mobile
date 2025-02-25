import 'package:flutter/material.dart';

import '../../../../models/models.dart';
import '../../../../utils/utils.dart';

class Summary extends StatelessWidget {
  final GetProductJsonModel product;
  const Summary({
    required this.product,
    super.key,
  });

  Widget item({
    required String title,
    required String value,
    required bool addBrazilianCoin,
    required int decimalHouses,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey[600])),
          Text(
            "${value.toBrazilianNumber(decimalHouses)}" +
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
          value: product.quantity.toString(),
          addBrazilianCoin: false,
          decimalHouses: 3,
        ),
        item(
          title: "Preço",
          value: product.value.toString(),
          addBrazilianCoin: true,
          decimalHouses: 2,
        ),
        item(
          title: "Total",
          value: (product.quantity * (product.value ?? 0)).toString(),
          addBrazilianCoin: true,
          decimalHouses: 2,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
        ),
      ],
    );
  }
}
