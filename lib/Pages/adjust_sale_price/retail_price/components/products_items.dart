import 'package:celta_inventario/components/global_widgets/global_widgets.dart';
import 'package:celta_inventario/providers/providers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsItems extends StatelessWidget {
  const ProductsItems({super.key});

  @override
  Widget build(BuildContext context) {
    AdjustSalePriceProvider adjustSalePriceProvider = Provider.of(context);

    return Expanded(
      child: ListView.builder(
        itemCount: adjustSalePriceProvider.products.length,
        itemBuilder: (context, index) {
          final product = adjustSalePriceProvider.products[index];

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TitleAndSubtitle.titleAndSubtitle(
                    // title: "Produto",
                    subtitle: product.name,
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "PLU",
                    subtitle: product.plu,
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: product.retailPracticedPrice != null &&
                            product.retailPracticedPrice! > 0
                        ? "Varejo"
                        : null,
                    subtitle: product.retailPracticedPrice != null &&
                            product.retailPracticedPrice! > 0
                        ? product.retailPracticedPrice
                            .toString()
                            .toBrazilianNumber()
                            .addBrazilianCoin()
                        : "Sem preço de varejo",
                    subtitleColor: product.retailPracticedPrice != null &&
                            product.retailPracticedPrice! > 0
                        ? Theme.of(context).colorScheme.primary
                        : Colors.black,
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: product.wholePracticedPrice != null &&
                            product.wholePracticedPrice! > 0
                        ? "Atacado"
                        : null,
                    subtitle: product.wholePracticedPrice != null &&
                            product.wholePracticedPrice! > 0
                        ? product.wholePracticedPrice
                            .toString()
                            .toBrazilianNumber()
                            .addBrazilianCoin()
                        : "Sem preço de atacado",
                    subtitleColor: product.wholePracticedPrice != null &&
                            product.wholePracticedPrice! > 0
                        ? Theme.of(context).colorScheme.primary
                        : Colors.black,
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: product.wholePracticedPrice != null &&
                            product.wholePracticedPrice! > 0
                        ? "Ecommerce"
                        : null,
                    subtitle: product.eCommercePracticedPrice != null &&
                            product.eCommercePracticedPrice! > 0
                        ? product.eCommercePracticedPrice
                            .toString()
                            .toBrazilianNumber()
                            .addBrazilianCoin()
                        : "Sem preço de ecommerce",
                    subtitleColor: product.eCommercePracticedPrice != null &&
                            product.eCommercePracticedPrice! > 0
                        ? Theme.of(context).colorScheme.primary
                        : Colors.black,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
