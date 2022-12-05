import 'package:celta_inventario/Components/Price_conference/price_conference_send_print_button.dart';
import 'package:celta_inventario/components/Global_widgets/personalized_card.dart';
import 'package:flutter/material.dart';

import '../../providers/price_conference_provider.dart';

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
    required PriceConferenceProvider priceConferenceProvider,
  }) {
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
                itemCount: widget.priceConferenceProvider.productsCount,
                itemBuilder: (context, index) {
                  var product = widget.priceConferenceProvider.products[index];
                  return GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      if (widget.priceConferenceProvider.isLoading ||
                          widget.priceConferenceProvider.isSendingToPrint)
                        return;
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
                              priceConferenceProvider:
                                  widget.priceConferenceProvider,
                            ),
                            values(
                              title: "PLU",
                              value: product.PriceLookUp,
                              index: index,
                              priceConferenceProvider:
                                  widget.priceConferenceProvider,
                            ),
                            values(
                              title: "Embalagem",
                              value: product.PackingQuantity,
                              index: index,
                              priceConferenceProvider:
                                  widget.priceConferenceProvider,
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
                              priceConferenceProvider:
                                  widget.priceConferenceProvider,
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
                              priceConferenceProvider:
                                  widget.priceConferenceProvider,
                            ),
                            // values(
                            //   title: "Custo de reposição",
                            //   value: product.ReplacementCost == null
                            //       ? product.ReplacementCost.toString()
                            //       : double.tryParse(
                            //                   product.ReplacementCost.toString()
                            //                       .replaceAll(
                            //                           RegExp(r','), '.'))!
                            //               .toStringAsFixed(2)
                            //               .replaceAll(RegExp(r'\.'), ',') +
                            //           " R\$",
                            //   index: index,
                            //   priceConferenceProvider:
                            //       widget.priceConferenceProvider,
                            // ),
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
                              PriceConferenceSendPrintButton(
                                internalEnterpriseCode:
                                    widget.internalEnterpriseCode,
                                index: index,
                                priceConferenceProvider:
                                    widget.priceConferenceProvider,
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
