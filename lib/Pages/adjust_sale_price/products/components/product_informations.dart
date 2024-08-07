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

  @override
  Widget build(BuildContext context) {
    final EnterpriseModel enterprise =
        ModalRoute.of(context)!.settings.arguments! as EnterpriseModel;

    return Column(
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
          title: product.wholePracticedPrice != null &&
                  product.wholePracticedPrice! > 0
              ? "Atacado"
              : null,
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
          title: product.wholePracticedPrice != null &&
                  product.wholePracticedPrice! > 0
              ? "Ecommerce"
              : null,
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
              Navigator.of(context).pushNamed(
                APPROUTES.ADJUST_SALE_PRICE,
                arguments: {
                  "enterprise": enterprise,
                  "product": product,
                },
              );
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
    );
  }
}
