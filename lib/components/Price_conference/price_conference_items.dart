import 'package:celta_inventario/Components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/Components/Price_conference/price_conference_send_print_button.dart';
import 'package:celta_inventario/components/Global_widgets/personalized_card.dart';
import 'package:celta_inventario/utils/convert_string.dart';
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
                              title: "Quantidade mínima para atacado",
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
