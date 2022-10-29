import 'package:celta_inventario/components/personalized_card.dart';
import 'package:celta_inventario/procedures/consult_price_procedure/consult_price_page/consult_price_provider.dart';
import 'package:celta_inventario/procedures/consult_price_procedure/consult_price_page/consult_price_send_print_button.dart';
import 'package:celta_inventario/utils/show_error_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConsultPriceItems extends StatefulWidget {
  final ConsultPriceProvider consultPriceProvider;
  final int internalEnterpriseCode;
  const ConsultPriceItems({
    required this.internalEnterpriseCode,
    required this.consultPriceProvider,
    Key? key,
  }) : super(key: key);

  @override
  State<ConsultPriceItems> createState() => _ConsultPriceItemsState();
}

class _ConsultPriceItemsState extends State<ConsultPriceItems> {
  int selectedIndex = -1;

  TextStyle _fontStyle = const TextStyle(
    fontSize: 17,
    color: Colors.black,
    fontFamily: 'OpenSans',
  );
  TextStyle _fontBoldStyle = const TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  Widget values({
    required String title,
    required String value,
    required int index,
    required ConsultPriceProvider consultPriceProvider,
  }) {
    // print(consultPriceProvider.products[index].toString());
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          "${title}: ",
          style: _fontStyle,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            style: _fontBoldStyle,
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.consultPriceProvider.productsCount,
                itemBuilder: (context, index) {
                  var product = widget.consultPriceProvider.products[index];
                  return GestureDetector(
                    onTap: () {
                      if (widget.consultPriceProvider.isLoading ||
                          widget.consultPriceProvider.isSendingToPrint) return;
                      setState(() {
                        if (selectedIndex == index) {
                          selectedIndex = -1;
                        } else {
                          selectedIndex = index;
                        }
                      });
                    },
                    child: PersonalizedCard.personalizedCard(
                      context: context,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            values(
                              title: "Nome",
                              value: product.ProductName,
                              index: index,
                              consultPriceProvider: widget.consultPriceProvider,
                            ),
                            values(
                              title: "PLU",
                              value: product.PriceLookUp,
                              index: index,
                              consultPriceProvider: widget.consultPriceProvider,
                            ),
                            values(
                              title: "Embalagem",
                              value: product.PackingQuantity,
                              index: index,
                              consultPriceProvider: widget.consultPriceProvider,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Preço: ",
                                  style: _fontStyle,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    product.SalePracticedRetail + " R\$",
                                    style: const TextStyle(
                                      fontSize: 17,
                                      color: Colors.green,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            values(
                              title: "Permite venda",
                              value: product.AllowSale == 1 ? "Sim" : "Não",
                              index: index,
                              consultPriceProvider: widget.consultPriceProvider,
                            ),
                            values(
                              title: "Estoque atual",
                              value: product.CurrentStock,
                              //  == null
                              //     ? product.CurrentStock.toString()
                              //     : double.tryParse(
                              //             product.CurrentStock.toString()
                              //                 .replaceAll(RegExp(r','), '.'))!
                              //         .toStringAsFixed(3)
                              //         .replaceAll(RegExp(r'\.'), ','),
                              index: index,
                              consultPriceProvider: widget.consultPriceProvider,
                            ),
                            values(
                              title: "Custo de reposição: ",
                              value: product.ReplacementCost == null
                                  ? product.ReplacementCost.toString()
                                  : double.tryParse(
                                              product.ReplacementCost.toString()
                                                  .replaceAll(
                                                      RegExp(r','), '.'))!
                                          .toStringAsFixed(2)
                                          .replaceAll(RegExp(r'\.'), ',') +
                                      " R\$",
                              index: index,
                              consultPriceProvider: widget.consultPriceProvider,
                            ),
                            Container(
                              // color: Colors.amber,
                              height: 22,
                              child: Row(
                                // mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Etiqueta pendente: ",
                                        style: _fontStyle,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        product.EtiquetaPendenteDescricao,
                                        style: _fontBoldStyle,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    selectedIndex != index
                                        ? Icons.arrow_drop_down_sharp
                                        : Icons.arrow_drop_up_sharp,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 40,
                                  ),
                                ],
                              ),
                            ),
                            if (selectedIndex == index)
                              ConsultPriceSendPrintButton(
                                internalEnterpriseCode:
                                    widget.internalEnterpriseCode,
                                index: index,
                                consultPriceProvider:
                                    widget.consultPriceProvider,
                                productPackingCode: product.ProductPackingCode,
                                etiquetaPendenteDescricao:
                                    product.EtiquetaPendenteDescricao,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
