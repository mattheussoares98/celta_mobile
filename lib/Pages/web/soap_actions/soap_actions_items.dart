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
              crossAxisCount: 5,
              // childAspectRatio: 0.7,
            ),
            shrinkWrap: true,
            itemCount: webProvider.clientsNames.toList().length,
            itemBuilder: (_, index) {
              final clientName = webProvider.clientsNames.toList()[index];

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    child: Column(
                      children: [
                        Row(
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
                          "Mês retrasado: ${webProvider.getTotalSoapActions(months: [
                                Months.AntiPenultimateMonth
                              ], clientName: clientName)}",
                        ),
                        Text(
                          "Mês passado: ${webProvider.getTotalSoapActions(months: [
                                Months.PenultimateMonth
                              ], clientName: clientName)}",
                        ),
                        Text(
                          "Mês atual: ${webProvider.getTotalSoapActions(months: [
                                Months.AtualMonth
                              ], clientName: clientName)}",
                        ),
                        Text(
                          "Últimos 3 meses: ${webProvider.getTotalSoapActions(months: [
                                Months.AtualMonth,
                                Months.PenultimateMonth,
                                Months.AntiPenultimateMonth,
                              ], clientName: clientName)}",
                        ),
                        TextButton(
                          onPressed: () {
                            showDialog(
                                context: pageContext,
                                builder: (_) {
                                  return const AlertDialog(
                                    title: const Text(
                                        "Implemente aqui os detalhes"),
                                    contentPadding: const EdgeInsets.all(0),
                                    insetPadding: const EdgeInsets.all(10),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: [],
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
