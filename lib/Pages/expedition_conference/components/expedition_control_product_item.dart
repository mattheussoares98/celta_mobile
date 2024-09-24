import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../models/expedition_control/expedition_control.dart';
import '../../../utils/utils.dart';

class ExpeditionControlProductItem extends StatelessWidget {
  final ExpeditionControlProductModel product;
  const ExpeditionControlProductItem({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TitleAndSubtitle.titleAndSubtitle(
                subtitle: "${product.Name}  ${product.Packing}"),
            TitleAndSubtitle.titleAndSubtitle(
              title: "PLU",
              subtitle: product.PriceLookUp,
            ),
            TitleAndSubtitle.titleAndSubtitle(
              title: "Qtd",
              subtitle: product.Quantity.toString().toBrazilianNumber(3),
            ),
          ],
        ),
      ),
    );
  }
}
