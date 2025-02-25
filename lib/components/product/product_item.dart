import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../models/products/products.dart';
import '../../../utils/utils.dart';

class ProductItem extends StatelessWidget {
  final GetProductJsonModel product;
  final Widget? componentAfterProductInformations;
  final bool? showCosts;
  final bool? showLastBuyEntrance;
  final bool? showPrice;
  final bool? showWholeInformations;
  final bool? showMargins;
  final Widget? componentBeforeProductInformations;
  final int? enterpriseCode;
  const ProductItem({
    required this.product,
    required this.componentAfterProductInformations,
    required this.enterpriseCode,
    this.componentBeforeProductInformations,
    this.showPrice = true,
    this.showWholeInformations = true,
    this.showCosts,
    this.showLastBuyEntrance,
    this.showMargins,
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
            Column(
              children: [
                if (componentBeforeProductInformations != null)
                  componentBeforeProductInformations!,
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
                        if (showLastBuyEntrance == true)
                          LastBuyEntrance(product: product),
                        if (showCosts == true) Costs(product: product),
                        if (showMargins == true) Margins(product: product)
                      ],
                    ),
                  ],
                ),
                if (showPrice == true)
                  getTitleAndSubtitle(
                    value: product.retailPracticedPrice.toString(),
                    isPrice: true,
                    successMessage: "Preço de venda",
                    errorMessage: "Sem preço de venda",
                    context: context,
                  ),
                TitleAndSubtitle.titleAndSubtitle(
                  title: _getAtualStock(product, enterpriseCode) != null
                      ? "Estoque atual"
                      : null,
                  subtitle: _getStockValueMessage(product, enterpriseCode),
                  subtitleColor:
                      _getStockSubtitleColor(context, product, enterpriseCode),
                ),
                if (showWholeInformations == true)
                  Column(
                    children: [
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
                    ],
                  ),
                if (!product.liquidCost.toString().contains("-1") &&
                    showCosts == true)
                  //quando o usuário não possui permissão para consultar o estoque, a API retorna "-1.0"
                  getTitleAndSubtitle(
                    isPrice: true,
                    value: product.liquidCost.toString(),
                    successMessage: "Custo líquido",
                    errorMessage: "Sem custo líquido",
                    context: context,
                  ),
              ],
            ),
            if (componentAfterProductInformations != null)
              componentAfterProductInformations!,
          ],
        ),
      ),
    );
  }
}

StocksModel? _getAtualStock(GetProductJsonModel product, int? enterpriseCode) {
  final atualStock = product.stocks!.where((element) =>
      element.stockName == "Estoque Atual" &&
      element.enterpriseCode == enterpriseCode);
  if (atualStock.isNotEmpty && atualStock.first.stockQuantity != null) {
    return atualStock.first;
  }
  return null;
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

String _getStockValueMessage(GetProductJsonModel product, int? enterpriseCode) {
  final atualStock = _getAtualStock(product, enterpriseCode);

  if (atualStock == null || atualStock.stockQuantity == 0) {
    return "Sem estoque atual";
  } else if (atualStock.stockQuantity! >= 0) {
    return atualStock.stockQuantity!.toString().toBrazilianNumber();
  } else {
    return "Estoque negativo: " +
        atualStock.stockQuantity!.toString().toBrazilianNumber();
  }
}

Color _getStockSubtitleColor(
    BuildContext context, GetProductJsonModel product, int? enterpriseCode) {
  final atualStock = _getAtualStock(product, enterpriseCode);

  if (atualStock == null) {
    return Colors.black;
  } else if (atualStock.stockQuantity == 0) {
    return Colors.black;
  } else if (atualStock.stockQuantity! > 0) {
    return Theme.of(context).colorScheme.primary;
  } else {
    return Colors.red;
  }
}
