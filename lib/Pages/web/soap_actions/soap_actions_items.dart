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
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          if (webProvider.lastThreeMonths[index]
                                                  .adjustStockConfirmQuantity !=
                                              null)
                                            Text(
                                                "adjustStockConfirmQuantity ${webProvider.lastThreeMonths[index].adjustStockConfirmQuantity}"),
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
