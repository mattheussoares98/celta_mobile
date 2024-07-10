import 'package:celta_inventario/models/enterprise/enterprise.dart';

import '../../../../components/components.dart';
import '../../../../models/soap/soap.dart';
import '../../../../pages/adjust_sale_price/adjust_sale_price.dart';
import '../../../../utils/utils.dart';

import 'package:flutter/material.dart';

class ProductItem extends StatefulWidget {
  final Function() updateSelectedIndex;
  final GetProductJsonModel product;
  final int index;
  final int? selectedIndex;
  const ProductItem({
    required this.updateSelectedIndex,
    required this.product,
    required this.index,
    required this.selectedIndex,
    super.key,
  });

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    final EnterpriseModel enterprise =
        ModalRoute.of(context)!.settings.arguments! as EnterpriseModel;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TitleAndSubtitle.titleAndSubtitle(
              // title: "Produto",
              subtitle: widget.product.name,
            ),
            TitleAndSubtitle.titleAndSubtitle(
              title: "PLU",
              subtitle: widget.product.plu,
            ),
            TitleAndSubtitle.titleAndSubtitle(
              title: widget.product.retailPracticedPrice != null &&
                      widget.product.retailPracticedPrice! > 0
                  ? "Varejo"
                  : null,
              subtitle: widget.product.retailPracticedPrice != null &&
                      widget.product.retailPracticedPrice! > 0
                  ? widget.product.retailPracticedPrice
                      .toString()
                      .toBrazilianNumber()
                      .addBrazilianCoin()
                  : "Sem preço de varejo",
              subtitleColor: widget.product.retailPracticedPrice != null &&
                      widget.product.retailPracticedPrice! > 0
                  ? Theme.of(context).colorScheme.primary
                  : Colors.black,
            ),
            TitleAndSubtitle.titleAndSubtitle(
              title: widget.product.wholePracticedPrice != null &&
                      widget.product.wholePracticedPrice! > 0
                  ? "Atacado"
                  : null,
              subtitle: widget.product.wholePracticedPrice != null &&
                      widget.product.wholePracticedPrice! > 0
                  ? widget.product.wholePracticedPrice
                      .toString()
                      .toBrazilianNumber()
                      .addBrazilianCoin()
                  : "Sem preço de atacado",
              subtitleColor: widget.product.wholePracticedPrice != null &&
                      widget.product.wholePracticedPrice! > 0
                  ? Theme.of(context).colorScheme.primary
                  : Colors.black,
            ),
            TitleAndSubtitle.titleAndSubtitle(
              title: widget.product.wholePracticedPrice != null &&
                      widget.product.wholePracticedPrice! > 0
                  ? "Ecommerce"
                  : null,
              subtitle: widget.product.eCommercePracticedPrice != null &&
                      widget.product.eCommercePracticedPrice! > 0
                  ? widget.product.eCommercePracticedPrice
                      .toString()
                      .toBrazilianNumber()
                      .addBrazilianCoin()
                  : "Sem preço de ecommerce",
              subtitleColor: widget.product.eCommercePracticedPrice != null &&
                      widget.product.eCommercePracticedPrice! > 0
                  ? Theme.of(context).colorScheme.primary
                  : Colors.black,
              otherWidget: InkWell(
                onTap: widget.updateSelectedIndex,
                child: Row(
                  children: [
                    Text(
                      "Alterar preços",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Icon(
                      widget.selectedIndex == widget.index
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
            if (widget.selectedIndex == widget.index)
              Column(
                children: [
                  PriceTypeRadios(enterpriseModel: enterprise),
                  const SaleTypeRadios(),
                  const ReplicationParameters(),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
