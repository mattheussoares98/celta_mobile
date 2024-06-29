import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../providers/providers.dart';

class SoapActionsItems extends StatelessWidget {
  final BuildContext pageContext;
  const SoapActionsItems({
    required this.pageContext,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    WebProvider webProvider = Provider.of(context);
    return Column(
      children: [
        Text("Total de clientes: ${webProvider.clientsNames.length}",
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            )),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              // childAspectRatio: 0.7,
            ),
            shrinkWrap: true,
            itemCount: webProvider.clientsNames.length,
            itemBuilder: (_, index) {
              final clientName = webProvider.clientsNames[index];

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              clientName.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                            "Mês atual: ${webProvider.getTotalRequestsByMonth(clientName: clientName, monthSoapActions: webProvider.atualMonth)}"),
                        Text(
                            "Mês passado: ${webProvider.getTotalRequestsByMonth(clientName: clientName, monthSoapActions: webProvider.penultimateMonth)}"),
                        Text(
                            "Mês retrasado: ${webProvider.getTotalRequestsByMonth(clientName: clientName, monthSoapActions: webProvider.antiPenultimateMonth)}"),
                        Text(
                            "Últimos 3 meses: ${webProvider.getTotalRequestsByMonth(clientName: clientName, monthSoapActions: webProvider.lastThreeMonths)}"),
                        TextButton(
                          onPressed: () {
                            showDialog(
                                context: pageContext,
                                builder: (_) {
                                  return AlertDialog(
                                    title: const Text("Detalhes"),
                                    contentPadding: const EdgeInsets.all(0),
                                    insetPadding: const EdgeInsets.all(10),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          if (webProvider.lastThreeMonths[index]
                                                  .adjustStockConfirmQuantity !=
                                              null)
                                            Text(
                                                "Ajuste de estoque ${webProvider.lastThreeMonths[index].adjustStockConfirmQuantity}"),
                                          if (webProvider.lastThreeMonths[index]
                                                  .priceConferenceGetProductOrSendToPrint !=
                                              null)
                                            Text(
                                              "Consulta de preços: " +
                                                  webProvider
                                                      .lastThreeMonths[index]
                                                      .priceConferenceGetProductOrSendToPrint
                                                      .toString(),
                                            ),
                                          if (webProvider.lastThreeMonths[index]
                                                  .inventoryEntryQuantity !=
                                              null)
                                            Text(
                                              "Processo de inventário: " +
                                                  webProvider
                                                      .lastThreeMonths[index]
                                                      .inventoryEntryQuantity
                                                      .toString(),
                                            ),
                                          if (webProvider.lastThreeMonths[index]
                                                  .receiptEntryQuantity !=
                                              null)
                                            Text(
                                              "Qtd produto recebimento: " +
                                                  webProvider
                                                      .lastThreeMonths[index]
                                                      .receiptEntryQuantity
                                                      .toString(),
                                            ),
                                          if (webProvider.lastThreeMonths[index]
                                                  .receiptLiberate !=
                                              null)
                                            Text(
                                              "Liberação doc recebimento: " +
                                                  webProvider
                                                      .lastThreeMonths[index]
                                                      .receiptLiberate
                                                      .toString(),
                                            ),
                                          if (webProvider.lastThreeMonths[index]
                                                  .saleRequestSave !=
                                              null)
                                            Text(
                                              "Pedido de vendas: " +
                                                  webProvider
                                                      .lastThreeMonths[index]
                                                      .saleRequestSave
                                                      .toString(),
                                            ),
                                          if (webProvider.lastThreeMonths[index]
                                                  .transferBetweenStocksConfirmAdjust !=
                                              null)
                                            Text(
                                              "Transferência entre estoques: " +
                                                  webProvider
                                                      .lastThreeMonths[index]
                                                      .transferBetweenStocksConfirmAdjust
                                                      .toString(),
                                            ),
                                          if (webProvider.lastThreeMonths[index]
                                                  .transferBetweenPackageConfirmAdjust !=
                                              null)
                                            Text(
                                              "Transferência entre embalagens: " +
                                                  webProvider
                                                      .lastThreeMonths[index]
                                                      .transferBetweenPackageConfirmAdjust
                                                      .toString(),
                                            ),
                                          if (webProvider.lastThreeMonths[index]
                                                  .transferRequestSave !=
                                              null)
                                            Text(
                                              "Pedido de transferência: " +
                                                  webProvider
                                                      .lastThreeMonths[index]
                                                      .transferRequestSave
                                                      .toString(),
                                            ),
                                          if (webProvider.lastThreeMonths[index]
                                                  .customerRegister !=
                                              null)
                                            Text(
                                              "Cadastro de cliente: " +
                                                  webProvider
                                                      .lastThreeMonths[index]
                                                      .customerRegister
                                                      .toString(),
                                            ),
                                          if (webProvider.lastThreeMonths[index]
                                                  .buyRequestSave !=
                                              null)
                                            Text(
                                              "Pedido de compras: " +
                                                  webProvider
                                                      .lastThreeMonths[index]
                                                      .buyRequestSave
                                                      .toString(),
                                            ),
                                          if (webProvider.lastThreeMonths[index]
                                                  .researchPricesInsertPrice !=
                                              null)
                                            Text(
                                              "Preço concorrente: " +
                                                  webProvider
                                                      .lastThreeMonths[index]
                                                      .researchPricesInsertPrice
                                                      .toString(),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: const Text("Visualizar detalhes"),
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
    );
  }
}
