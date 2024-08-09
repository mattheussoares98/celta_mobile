import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../models/soap/products/products.dart';
import '../../../utils/utils.dart';
import 'components.dart';

class ProductItem extends StatefulWidget {
  final GetProductJsonModel product;
  final int internalEnterpriseCode;
  final int index;
  const ProductItem({
    required this.product,
    required this.internalEnterpriseCode,
    required this.index,
    super.key,
  });

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  Widget getTitleAndSubtitle({
    required String value,
    required String successMessage,
    required String errorMessage,
    required bool isPrice,
  }) {
    bool hasValue =
        double.tryParse(value) != null && double.tryParse(value)! > 0;

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

  String getStockValueMessage() {
    final currentStock = widget.product.stocks!
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

  Color getStockSubtitleColor() {
    final currentStock = widget.product.stocks!
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
              subtitle: widget.product.name.toString() +
                  " (${widget.product.packingQuantity})",
            ),
            Row(
              children: [
                Expanded(
                  child: TitleAndSubtitle.titleAndSubtitle(
                    title: "PLU",
                    subtitle: widget.product.plu,
                  ),
                ),
                OpenDialogProductInformations(product: widget.product),
              ],
            ),
            getTitleAndSubtitle(
              value: widget.product.retailPracticedPrice.toString(),
              isPrice: true,
              successMessage: "Preço de venda",
              errorMessage: "Sem preço de venda",
            ),
            TitleAndSubtitle.titleAndSubtitle(
              title: widget.product.stocks!
                          .where(
                              (element) => element.stockName == "Estoque Atual")
                          .first
                          .stockQuantity! >
                      0
                  ? "Estoque atual"
                  : null,
              subtitle: getStockValueMessage(),
              subtitleColor: getStockSubtitleColor(),
            ),
            getTitleAndSubtitle(
              isPrice: true,
              value: widget.product.wholePracticedPrice.toString(),
              successMessage: "Preço de atacado",
              errorMessage: "Sem preço de atacado",
            ),
            getTitleAndSubtitle(
              isPrice: false,
              value: widget.product.minimumWholeQuantity.toString(),
              successMessage: "Qtd mín atacado",
              errorMessage: "Sem qtd mín p/ atacado",
            ),
            if (!widget.product.liquidCost.toString().contains("-1"))
              //quando o usuário não possui permissão para consultar o estoque, a API retorna "-1.0"
              getTitleAndSubtitle(
                isPrice: true,
                value: widget.product.liquidCost.toString(),
                successMessage: "Custo líquido",
                errorMessage: "Sem custo líquido",
              ),
            SendToPrintButton(
              internalEnterpriseCode: widget.internalEnterpriseCode,
              index: widget.index,
              productPackingCode: widget.product.productPackingCode!,
              etiquetaPendente: widget.product.pendantPrintLabel,
            ),
          ],
        ),
      ),
    );
  }
}
