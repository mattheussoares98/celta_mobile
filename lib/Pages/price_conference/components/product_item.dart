import 'package:flutter/material.dart';

import '../../../components/global_widgets/global_widgets.dart';
import '../../../models/price_conference/price_conference.dart';
import '../../../utils/utils.dart';
import 'components.dart';

class ProductItem extends StatefulWidget {
  final PriceConferenceProductsModel product;
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
    if (double.tryParse(widget.product.CurrentStock) == null ||
        double.tryParse(widget.product.CurrentStock) == 0) {
      return "Sem estoque atual";
    } else if (double.parse(widget.product.CurrentStock) > 0) {
      return ConvertString.convertToBrazilianNumber(
        double.parse(widget.product.CurrentStock).toString(),
      );
    } else {
      return "Estoque negativo: " +
          ConvertString.convertToBrazilianNumber(widget.product.CurrentStock);
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
              value: widget.product.ProductName,
            ),
            TitleAndSubtitle.titleAndSubtitle(
              title: "PLU",
              value: widget.product.PriceLookUp,
              otherWidget: costs(
                context: context,
                product: widget.product,
              ),
            ),
            TitleAndSubtitle.titleAndSubtitle(
              title: "Embalagem",
              value: widget.product.PackingQuantity,
            ),
            getTitleAndSubtitle(
              value: widget.product.SalePracticedRetail,
              successMessage: "Preço de venda",
              errorMessage: "Sem preço de venda",
            ),
            TitleAndSubtitle.titleAndSubtitle(
              value: widget.product.AllowSale
                  ? "Permite venda"
                  : "Não permite venda",
              subtitleColor: widget.product.AllowSale
                  ? Theme.of(context).colorScheme.primary
                  : Colors.red,
            ),
            TitleAndSubtitle.titleAndSubtitle(
              title: double.tryParse(widget.product.CurrentStock) != null &&
                      double.tryParse(widget.product.CurrentStock)! > 0
                  ? "Estoque atual"
                  : null,
              value: getStockValueMessage(),
              subtitleColor:
                  double.tryParse(widget.product.CurrentStock) != null &&
                          double.tryParse(widget.product.CurrentStock)! > 0
                      ? Theme.of(context).colorScheme.primary
                      : Colors.red,
            ),
            getTitleAndSubtitle(
              value: widget.product.SalePracticedWholeSale,
              successMessage: "Preço de atacado",
              errorMessage: "Sem preço de atacado",
            ),
            getTitleAndSubtitle(
              value: widget.product.MinimumWholeQuantity.toString(),
              successMessage: "Qtd mín atacado",
              errorMessage: "Sem qtd mín p/ atacado",
            ),
            if (!widget.product.LiquidCost.toString().contains("-1"))
              //quando o usuário não possui permissão para consultar o estoque, a API retorna "-1.0"
              getTitleAndSubtitle(
                value: widget.product.LiquidCost,
                successMessage: "Custo líquido",
                errorMessage: "Sem custo líquido",
              ),
            SendToPrintButton(
              internalEnterpriseCode: widget.internalEnterpriseCode,
              index: widget.index,
              productPackingCode: widget.product.ProductPackingCode,
              etiquetaPendente: widget.product.EtiquetaPendente,
            ),
          ],
        ),
      ),
    );
  }
}
