import 'package:flutter/material.dart';

import '../../components.dart';
import '../../../Models/models.dart';
import '../../../utils/utils.dart';

class Prices extends StatelessWidget implements MoreInformationWidget {
  @override
  MoreInformationType get type => MoreInformationType.prices;

  @override
  String get moreInformationName => "Preços";

  final GetProductJsonModel product;
  const Prices({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Text(
            "PREÇOS",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (product.retailPracticedPrice != null &&
            product.retailPracticedPrice! > 0)
          TitleAndSubtitle.titleAndSubtitle(
            title: "Varejo",
            subtitle: (product.retailPracticedPrice ?? 0)
                .toDouble()
                .toString()
                .toBrazilianNumber()
                .addBrazilianCoin(),
          ),
        if (product.wholePracticedPrice != null &&
            product.wholePracticedPrice! > 0)
          TitleAndSubtitle.titleAndSubtitle(
            title: "Atacado",
            subtitle: (product.wholePracticedPrice ?? 0)
                .toDouble()
                .toString()
                .toBrazilianNumber()
                .addBrazilianCoin(),
          ),
        if (product.eCommercePracticedPrice != null &&
            product.eCommercePracticedPrice! > 0)
          TitleAndSubtitle.titleAndSubtitle(
            title: "Ecommerce",
            subtitle: (product.eCommercePracticedPrice ?? 0)
                .toDouble()
                .toString()
                .toBrazilianNumber()
                .addBrazilianCoin(),
          ),
      ],
    );
  }
}
