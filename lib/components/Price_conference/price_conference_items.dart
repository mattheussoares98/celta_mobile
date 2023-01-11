import 'package:celta_inventario/Components/Global_widgets/title_and_value.dart';
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
                            TitleAndSubtitle.titleAndSubtitle(
                              title: "Nome",
                              value: product.ProductName,
                            ),
                            TitleAndSubtitle.titleAndSubtitle(
                              title: "PLU",
                              value: product.PriceLookUp,
                            ),
                            TitleAndSubtitle.titleAndSubtitle(
                              title: "Embalagem",
                              value: product.PackingQuantity,
                            ),
                            TitleAndSubtitle.titleAndSubtitle(
                                title: "Preço",
                                value: product.SalePracticedRetail + " R\$",
                                subtitleColor: Colors.green),

                            TitleAndSubtitle.titleAndSubtitle(
                              title: "Permite venda",
                              value: product.AllowSale == 1 ? "Sim" : "Não",
                            ),
                            TitleAndSubtitle.titleAndSubtitle(
                              title: "Estoque atual",
                              value: product.CurrentStock,
                              //  == null
                              //     ? product.CurrentStock.toString()
                              //     : double.tryParse(
                              //             product.CurrentStock.toString()
                              //                 .replaceAll(RegExp(r','), '.'))!
                              //         .toStringAsFixed(3)
                              //         .replaceAll(RegExp(r'\.'), ','),
                            ),
                            // TitleAndSubtitle.titleAndSubtitle(
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
                            // ),
                            TitleAndSubtitle.titleAndSubtitle(
                              title: "Etiqueta pendente",
                              value: product.EtiquetaPendente == true
                                  ? "Sim"
                                  : "Não",
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
                                internalEnterpriseCode:
                                    widget.internalEnterpriseCode,
                                index: index,
                                priceConferenceProvider:
                                    widget.priceConferenceProvider,
                                productPackingCode: product.ProductPackingCode,
                                etiquetaPendente: product.EtiquetaPendente,
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
