import 'package:flutter/material.dart';

import '../../models/price_conference/price_conference.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';
import '../global_widgets/global_widgets.dart';
import 'price_conference.dart';

class PriceConferenceItems extends StatefulWidget {
  final PriceConferenceProvider priceConferenceProvider;
  final int internalEnterpriseCode;
  const PriceConferenceItems({
    required this.internalEnterpriseCode,
    required this.priceConferenceProvider,
    Key? key,
  }) : super(key: key);

  @override
  State<PriceConferenceItems> createState() => _PriceConferenceItemsState();
}

class _PriceConferenceItemsState extends State<PriceConferenceItems> {
  int selectedIndex = -1;

  Widget itemOfList({
    required int index,
  }) {
    PriceConferenceProductsModel product =
        widget.priceConferenceProvider.products[index];
    return Container(
      child: InkWell(
          focusColor: Colors.white.withOpacity(0),
          hoverColor: Colors.white.withOpacity(0),
          splashColor: Colors.white.withOpacity(0),
          highlightColor: Colors.white.withOpacity(0),
        onTap: () {
          FocusScope.of(context).unfocus();
          if (widget.priceConferenceProvider.isLoading ||
              widget.priceConferenceProvider.isSendingToPrint) return;
          setState(() {
            if (selectedIndex == index) {
              selectedIndex = -1;
            } else {
              selectedIndex = index;
            }
          });
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Nome",
                  value: product.ProductName,
                ),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "PLU",
                  value: product.PriceLookUp,
                  // otherWidget: ShowAllStocks.showAllStocks(
                  //   productModel: product,
                  //   hasAssociatedsStock:
                  //       product.StorageAreaAddress != "" ||
                  //           product.StockByEnterpriseAssociateds
                  //                   .length >
                  //               0 ||
                  //           product.StockByEnterpriseAssociateds !=
                  //               null,
                  //   hasStocks: product.Stocks.length > 0,
                  //   context: context,
                  //   stockByEnterpriseAssociatedsLength:
                  //       product.StockByEnterpriseAssociateds == null
                  //           ? 0
                  //           : product.StockByEnterpriseAssociateds
                  //               .length,
                  //   stocksLength: product.Stocks.length,
                  // ),
                ),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Embalagem",
                  value: product.PackingQuantity,
                ),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Preço",
                  value: ConvertString.convertToBRL(
                    product.SalePracticedRetail,
                  ),
                  subtitleColor: Colors.green,
                ),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Preço de atacado",
                  value: ConvertString.convertToBRL(
                    product.SalePracticedWholeSale,
                  ),
                  subtitleColor: Colors.green,
                ),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Qtd mínima para atacado",
                  value: ConvertString.convertToBrazilianNumber(
                    product.MinimumWholeQuantity.toString(),
                  ),
                ),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Permite venda",
                  value: product.AllowSale == 1 ? "Sim" : "Não",
                ),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Estoque atual",
                  value: ConvertString.convertToBrazilianNumber(
                    product.CurrentStock,
                  ),
                ),
                if (!product.LiquidCost.toString().contains("-1"))
                  //quando o usuário não possui permissão para consultar o estoque, a API retorna "-1.0"
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Custo líquido",
                    value: ConvertString.convertToBRL(
                      product.LiquidCost,
                    ),
                  ),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Etiqueta pendente",
                  value: product.EtiquetaPendente == true ? "Sim" : "Não",
                  otherWidget: Icon(
                    selectedIndex != index
                        ? Icons.arrow_drop_down_sharp
                        : Icons.arrow_drop_up_sharp,
                    color: Theme.of(context).colorScheme.primary,
                    size: 30,
                  ),
                ),
                if (selectedIndex == index)
                  PriceConferenceSendPrintButton(
                    internalEnterpriseCode: widget.internalEnterpriseCode,
                    index: index,
                    productPackingCode: product.ProductPackingCode,
                    etiquetaPendente: product.EtiquetaPendente,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int itensPerLine = ResponsiveItems.getItensPerLine(context);
    int productsCount = widget.priceConferenceProvider.productsCount;

    return Expanded(
      child: Container(
        child: ListView.builder(
          itemCount: ResponsiveItems.itemCount(
            itemsCount: productsCount,
            context: context,
          ),
          itemBuilder: (context, index) {
            final startIndex = index * itensPerLine;
            final endIndex = (startIndex + itensPerLine <= productsCount)
                ? startIndex + itensPerLine
                : productsCount;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = startIndex; i < endIndex; i++)
                  Expanded(child: itemOfList(index: i)),
              ],
            );
          },
        ),
      ),
    );
  }
}
