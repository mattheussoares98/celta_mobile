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
                  otherWidget: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Fechar"),
                                )
                              ],
                              content: Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 30.0),
                                    child: Text(
                                      "CUSTOS",
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  TitleAndSubtitle.titleAndSubtitle(
                                    value: ConvertString.convertToBRL(
                                      product.FiscalCost,
                                    ),
                                    title: "Fiscal",
                                  ),
                                  const SizedBox(height: 8),
                                  TitleAndSubtitle.titleAndSubtitle(
                                    value: ConvertString.convertToBRL(
                                      product.FiscalLiquidCost,
                                    ),
                                    title: "Fiscal líquido",
                                  ),
                                  const SizedBox(height: 8),
                                  TitleAndSubtitle.titleAndSubtitle(
                                    value: ConvertString.convertToBRL(
                                      product.LiquidCost,
                                    ),
                                    title: "Líquido",
                                  ),
                                  const SizedBox(height: 8),
                                  TitleAndSubtitle.titleAndSubtitle(
                                    value: ConvertString.convertToBRL(
                                      product.LiquidCostMidle,
                                    ),
                                    title: "Líquido médio",
                                  ),
                                  const SizedBox(height: 8),
                                  TitleAndSubtitle.titleAndSubtitle(
                                    value: ConvertString.convertToBRL(
                                      product.OperationalCost,
                                    ),
                                    title: "Operacional",
                                  ),
                                  const SizedBox(height: 8),
                                  TitleAndSubtitle.titleAndSubtitle(
                                    value: ConvertString.convertToBRL(
                                      product.RealCost,
                                    ),
                                    title: "Real",
                                  ),
                                  const SizedBox(height: 8),
                                  TitleAndSubtitle.titleAndSubtitle(
                                    value: ConvertString.convertToBRL(
                                      product.RealLiquidCost,
                                    ),
                                    title: "Real líquido",
                                  ),
                                  const SizedBox(height: 8),
                                  TitleAndSubtitle.titleAndSubtitle(
                                    value: ConvertString.convertToBRL(
                                      product.ReplacementCost,
                                    ),
                                    title: "Reposição",
                                  ),
                                  const SizedBox(height: 8),
                                  TitleAndSubtitle.titleAndSubtitle(
                                    value: ConvertString.convertToBRL(
                                      product.ReplacementCostMidle,
                                    ),
                                    title: "Reposição médio",
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.info,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Custos",
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
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
