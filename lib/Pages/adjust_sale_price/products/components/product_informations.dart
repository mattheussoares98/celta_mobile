import 'package:flutter/material.dart';

import '../../../../components/components.dart';
import '../../../../models/enterprise/enterprise.dart';
import '../../../../models/soap/soap.dart';
import '../../../../utils/utils.dart';

class ProductInformations extends StatelessWidget {
  final GetProductJsonModel product;
  final int index;
  const ProductInformations({
    required this.product,
    required this.index,
    super.key,
  });

  void onTapProduct(BuildContext context, EnterpriseModel enterprise) {
    Navigator.of(context).pushNamed(
      APPROUTES.ADJUST_SALE_PRICE,
      arguments: {
        "enterprise": enterprise,
        "product": product,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final EnterpriseModel enterprise =
        ModalRoute.of(context)!.settings.arguments! as EnterpriseModel;

    return InkWell(
      onTap: () {
        onTapProduct(context, enterprise);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TitleAndSubtitle.titleAndSubtitle(
              // title: "Produto",
              subtitle: "${product.name} (${product.packingQuantity})",
            ),
            TitleAndSubtitle.titleAndSubtitle(
              title: "PLU",
              subtitle: product.plu,
            ),
            TitleAndSubtitle.titleAndSubtitle(
              subtitle: product.retailPracticedPrice != null &&
                      product.retailPracticedPrice! > 0
                  ? "Varejo: " +
                      product.retailPracticedPrice
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
              subtitle: product.wholePracticedPrice != null &&
                      product.wholePracticedPrice! > 0
                  ? "Atacado: " +
                      product.wholePracticedPrice
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
              subtitle: product.eCommercePracticedPrice != null &&
                      product.eCommercePracticedPrice! > 0
                  ? "Ecommerce: " +
                      product.eCommercePracticedPrice
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
                  onTapProduct(context, enterprise);
                },
                child: Row(
                  children: [
                    Text(
                      "Alterar preços",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
