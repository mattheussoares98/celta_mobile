import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../Models/models.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';

class QuantitysAndPrices extends StatelessWidget {
  final GetProductJsonModel product;
  final int selectedIndex;
  final void Function() changeFocus;
  final String enterpriseCode;

  const QuantitysAndPrices({
    required this.product,
    required this.selectedIndex,
    required this.changeFocus,
    required this.enterpriseCode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider = Provider.of(context);

    double productDiscount =
        saleRequestProvider.getProductDiscount(product) ?? 0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _titleAndSubtitle(
                    flex: 20,
                    title: "Qtd",
                    subtitle: product.quantity
                        .toStringAsFixed(3)
                        .replaceAll(RegExp(r'\.'), ','),
                  ),
                  _titleAndSubtitle(
                    flex: 20,
                    title: "Preço",
                    subtitle: ConvertString.convertToBRL(
                      product.value.toString(),
                    ),
                  ),
                  if (productDiscount > 0)
                    _titleAndSubtitle(
                      flex: 30,
                      title: "Desconto",
                      subtitle: ConvertString.convertToBRL(productDiscount),
                    ),
                  const SizedBox(width: 5),
                  _titleAndSubtitle(
                    flex: 30,
                    title: "Total",
                    subtitle: ConvertString.convertToBRL(
                        (product.value! * product.quantity) - productDiscount),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (productDiscount > 0)
          Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                TitleAndSubtitle.titleAndSubtitle(
                  subtitleColor: Theme.of(context).colorScheme.primary,
                  subtitle: saleRequestProvider.getDiscountDescription(
                    product,
                    enterpriseCode,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

Widget _titleAndSubtitle({
  required String title,
  required String subtitle,
  required int flex,
}) {
  return Expanded(
    flex: flex,
    child: Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 100, 97, 97),
            ),
          ),
          const SizedBox(height: 5),
          FittedBox(
            child: Text(
              subtitle,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    ),
  );
}
