import 'package:flutter/material.dart';

import '../../../components/global_widgets/global_widgets.dart';
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
  }) {
    bool hasValue =
        double.tryParse(value) != null && double.tryParse(value)! > 0;

    return TitleAndSubtitle.titleAndSubtitle(
      title: hasValue ? successMessage : null,
      value: hasValue ? ConvertString.convertToBRL(value) : errorMessage,
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
              title: "Nome",
              value: widget.product.name,
            ),
            TitleAndSubtitle.titleAndSubtitle(
              title: "PLU",
              value: widget.product.plu,
              otherWidget: _costsAndStocks(
                context: context,
                product: widget.product,
              ),
            ),
            TitleAndSubtitle.titleAndSubtitle(
              title: "Embalagem",
              value: widget.product.packingQuantity,
            ),
            getTitleAndSubtitle(
              value: widget.product.retailSalePrice.toString(),
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
              value: getStockValueMessage(),
              subtitleColor: getStockSubtitleColor(),
            ),
            getTitleAndSubtitle(
              value: widget.product.wholeOfferPrice.toString(),
              successMessage: "Preço de atacado",
              errorMessage: "Sem preço de atacado",
            ),
            getTitleAndSubtitle(
              value: widget.product.minimumWholeQuantity.toString(),
              successMessage: "Qtd mín atacado",
              errorMessage: "Sem qtd mín p/ atacado",
            ),
            if (!widget.product.liquidCost.toString().contains("-1"))
              //quando o usuário não possui permissão para consultar o estoque, a API retorna "-1.0"
              getTitleAndSubtitle(
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

Widget _costsAndStocks({
  required BuildContext context,
  required GetProductJsonModel product,
}) {
  final PageController _pageController = PageController(initialPage: 0);
  return InkWell(
    child: Row(
      children: [
        Icon(
          Icons.info,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 5),
        Text(
          "Custo/Estoque/Compra",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
    onTap: () {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(20),
              insetPadding:
                  const EdgeInsets.symmetric(vertical: 70, horizontal: 20),
              content: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.height * 0.95,
                child: PageView(
                  controller: _pageController,
                  children: [
                    costs(context: context, product: product),
                    stocks(context: context, product: product),
                    lastBuyEntrance(context: context, product: product),
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextButton(
                        onPressed: () {
                          _pageController.animateToPage(
                            0,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        },
                        child: const FittedBox(child: Text('Custos')),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      flex: 3,
                      child: TextButton(
                        onPressed: () {
                          _pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        },
                        child: const FittedBox(child: Text('Estoques')),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      flex: 4,
                      child: TextButton(
                        onPressed: () {
                          _pageController.animateToPage(
                            2,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        },
                        child: const FittedBox(child: Text('Última compra')),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
    },
  );
}
