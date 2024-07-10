import 'package:celta_inventario/models/soap/products/get_product_json/get_product_json_model.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../components/components.dart';

class ProcuctItem extends StatelessWidget {
  final Function() updateSelectedIndex;
  final GetProductJsonModel product;
  final int index;
  final int selectedIndex;
  const ProcuctItem({
    required this.updateSelectedIndex,
    required this.product,
    required this.index,
    required this.selectedIndex,
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
                onTap: updateSelectedIndex,
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
  }
}
