import '../../../../components/components.dart';
import '../../../../providers/providers.dart';
import '../../../../utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsItems extends StatefulWidget {
  const ProductsItems({super.key});

  @override
  State<ProductsItems> createState() => _ProductsItemsState();
}

class _ProductsItemsState extends State<ProductsItems> {
  int? selectedIndex;

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
                    otherWidget: InkWell(
                      onTap: () {
                        if (selectedIndex == index) {
                          selectedIndex = null;
                        } else {
                          selectedIndex = index;
                        }
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          Text(
                            "Alterar preços",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Icon(
                            selectedIndex == index
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (selectedIndex == index)
                    const Text("Esse item aqui tá selecionado")
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
