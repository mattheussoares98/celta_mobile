import 'package:celta_inventario/components/title_and_subtitle.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/product/product.dart';
import '../../../../models/adjust_sale_price/adjust_sale_price.dart';
import '../../../../models/soap/soap.dart';
import '../../../../providers/providers.dart';

class ShowCosts extends StatelessWidget {
  final GetProductJsonModel product;
  const ShowCosts({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AdjustSalePriceProvider adjustSalePriceProvider = Provider.of(context);

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
                          .where(
                              (e) => e.saleTypeName == SaleTypeName.Ecommerce)
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
