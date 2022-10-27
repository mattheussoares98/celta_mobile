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

  Column values({
    required String title,
    required String value,
    required int index,
    required ConsultPriceProvider consultPriceProvider,
  }) {
    // print(consultPriceProvider.products[index].toString());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
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
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.grey,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.consultPriceProvider.productsCount,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (widget.consultPriceProvider.isLoading ||
                          widget.consultPriceProvider.isSendingToPrint) return;
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: PersonalizedCard.personalizedCard(
                      context: context,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            values(
                              title: "Nome",
                              value: widget.consultPriceProvider.products[index]
                                  .ProductName,
                              index: index,
                              consultPriceProvider: widget.consultPriceProvider,
                            ),
                            values(
                              title: "PLU",
                              value: widget.consultPriceProvider.products[index]
                                  .PriceLookUp,
                              index: index,
                              consultPriceProvider: widget.consultPriceProvider,
                            ),
                            values(
                              title: "Embalagem",
                              value: widget.consultPriceProvider.products[index]
                                  .PackingQuantity,
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
                                    widget.consultPriceProvider.products[index]
                                            .SalePracticedRetail +
                                        " R\$",
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
                              value: widget.consultPriceProvider.products[index]
                                          .AllowSale ==
                                      1
                                  ? "Sim"
                                  : "Não",
                              index: index,
                              consultPriceProvider: widget.consultPriceProvider,
                            ),
                            values(
                              title: "Custo de reposição",
                              value: double.tryParse(widget.consultPriceProvider
                                          .products[0].ReplacementCost
                                          .toString()
                                          .replaceAll(RegExp(r','), '.'))!
                                      .toStringAsFixed(2)
                                      .replaceAll(RegExp(r'\.'), ',') +
                                  " R\$",
                              index: index,
                              consultPriceProvider: widget.consultPriceProvider,
                            ),
                            values(
                              title: "Estoque atual",
                              value: widget.consultPriceProvider.products[index]
                                  .CurrentStock,
                              index: index,
                              consultPriceProvider: widget.consultPriceProvider,
                            ),
                            values(
                              title: "Saldo de venda",
                              value: widget.consultPriceProvider.products[index]
                                  .SaldoEstoqueVenda,
                              index: index,
                              consultPriceProvider: widget.consultPriceProvider,
                            ),
                            values(
                              title: "Etiqueta pendente",
                              value: widget.consultPriceProvider.products[index]
                                  .EtiquetaPendenteDescricao,
                              index: index,
                              consultPriceProvider: widget.consultPriceProvider,
                            ),
                            if (selectedIndex == index)
                              //só aparece a opção para marcar para impressão se
                              //o produto estiver selecionado
                              ConsultPriceSendPrintButton(
                                internalEnterpriseCode:
                                    widget.internalEnterpriseCode,
                                index: index,
                                consultPriceProvider:
                                    widget.consultPriceProvider,
                                productPackingCode: widget.consultPriceProvider
                                    .products[index].ProductPackingCode,
                                etiquetaPendenteDescricao: widget
                                    .consultPriceProvider
                                    .products[index]
                                    .EtiquetaPendenteDescricao,
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
