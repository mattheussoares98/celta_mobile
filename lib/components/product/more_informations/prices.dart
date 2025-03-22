import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components.dart';
import '../../../Models/models.dart';
import '../../../providers/providers.dart';
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
    AdjustSalePriceProvider adjustSalePriceProvider = Provider.of(context);

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
        if (adjustSalePriceProvider.saleTypes
            .where((e) => e.saleTypeName == SaleTypeName.Varejo)
            .isNotEmpty)
          TitleAndSubtitle.titleAndSubtitle(
            title: "Varejo",
            subtitle: (product.retailPracticedPrice ?? 0)
                .toDouble()
                .toString()
                .toBrazilianNumber()
                .addBrazilianCoin(),
          ),
        if (adjustSalePriceProvider.saleTypes
            .where((e) => e.saleTypeName == SaleTypeName.Atacado)
            .isNotEmpty)
          TitleAndSubtitle.titleAndSubtitle(
            title: "Atacado",
            subtitle: (product.wholePracticedPrice ?? 0)
                .toDouble()
                .toString()
                .toBrazilianNumber()
                .addBrazilianCoin(),
          ),
        if (adjustSalePriceProvider.saleTypes
            .where((e) => e.saleTypeName == SaleTypeName.Ecommerce)
            .isNotEmpty)
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
