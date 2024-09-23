import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../models/soap/products/products.dart';
import '../../../utils/utils.dart';

class ProductItem extends StatelessWidget {
  final GetProductJsonModel product;
  final Widget componentAfterProductInformations;
  final bool showCosts;
  const ProductItem({
    required this.product,
    required this.componentAfterProductInformations,
    required this.showCosts,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TitleAndSubtitle.titleAndSubtitle(
              title: "Produto",
              subtitle:
                  product.name.toString() + " (${product.packingQuantity})",
            ),
            Row(
              children: [
                Expanded(
                  child: TitleAndSubtitle.titleAndSubtitle(
                    title: "PLU",
                    subtitle: product.plu,
                  ),
                ),
                OpenDialogProductInformations(
                  product: product,
                  pages: [
                    Stocks(product: product),
                    StockAddress(product: product),
                    LastBuyEntrance(product: product),
                    if (showCosts) Costs(product: product),
                  ],
                ),
              ],
            ),
            getTitleAndSubtitle(
              value: product.retailPracticedPrice.toString(),
              isPrice: true,
              successMessage: "Preço de venda",
              errorMessage: "Sem preço de venda",
              context: context,
            ),
            TitleAndSubtitle.titleAndSubtitle(
              title: product.stocks!
                          .where(
                              (element) => element.stockName == "Estoque Atual")
                          .first
                          .stockQuantity! >
                      0
                  ? "Estoque atual"
                  : null,
              subtitle: getStockValueMessage(product),
              subtitleColor: getStockSubtitleColor(context, product),
            ),
            getTitleAndSubtitle(
              isPrice: true,
              value: product.wholePracticedPrice.toString(),
              successMessage: "Preço de atacado",
              errorMessage: "Sem preço de atacado",
              context: context,
            ),
            getTitleAndSubtitle(
              isPrice: false,
              value: product.minimumWholeQuantity.toString(),
              successMessage: "Qtd mín atacado",
              errorMessage: "Sem qtd mín p/ atacado",
              context: context,
            ),
            if (!product.liquidCost.toString().contains("-1") && showCosts)
              //quando o usuário não possui permissão para consultar o estoque, a API retorna "-1.0"
              getTitleAndSubtitle(
                isPrice: true,
                value: product.liquidCost.toString(),
                successMessage: "Custo líquido",
                errorMessage: "Sem custo líquido",
                context: context,
              ),
            componentAfterProductInformations,
          ],
        ),
      ),
    );
  }
}

Widget getTitleAndSubtitle({
  required String value,
  required String successMessage,
  required String errorMessage,
  required bool isPrice,
  required BuildContext context,
}) {
  bool hasValue = double.tryParse(value) != null && double.tryParse(value)! > 0;

  return TitleAndSubtitle.titleAndSubtitle(
    title: hasValue ? successMessage : null,
    subtitle: hasValue
        ? (isPrice
            ? value.toBrazilianNumber().addBrazilianCoin()
            : value.toBrazilianNumber())
        : errorMessage,
    subtitleColor:
        hasValue ? Theme.of(context).colorScheme.primary : Colors.black,
  );
}

String getStockValueMessage(GetProductJsonModel product) {
  final currentStock = product.stocks!
      .where((element) => element.stockName == "Estoque Atual")
      .first
      .stockQuantity;
  if (currentStock == null || currentStock == 0) {
    return "Sem estoque atual";
  } else if (currentStock >= 0) {
    return ConvertString.convertToBrazilianNumber(currentStock);
  } else {
    return "Estoque negativo: " +
        ConvertString.convertToBrazilianNumber(currentStock);
  }
}

Color getStockSubtitleColor(BuildContext context, GetProductJsonModel product) {
  final currentStock = product.stocks!
      .where((element) => element.stockName == "Estoque Atual")
      .first
      .stockQuantity;

  if (currentStock == null) {
    return Colors.black;
  } else if (currentStock == 0) {
    return Colors.black;
  } else if (currentStock > 0) {
    return Theme.of(context).colorScheme.primary;
  } else {
    return Colors.red;
  }
}
