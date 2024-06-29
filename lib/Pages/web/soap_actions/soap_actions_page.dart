import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../components/mixins/mixins.dart';
import '../../../providers/providers.dart';

class SoapActionsPage extends StatefulWidget {
  const SoapActionsPage({super.key});

  @override
  State<SoapActionsPage> createState() => _SoapActionsPageState();
}

class _SoapActionsPageState extends State<SoapActionsPage> with LoadingManager {
  @override
  Widget build(BuildContext context) {
    WebProvider webProvider = Provider.of(context);
    Future.delayed(Duration.zero, () {
      handleLoading(context, webProvider.isLoadingSoapActions);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("TOTAL DE REQUISIÇÕES"),
      ),
      body: webProvider.clientsNames.isEmpty
          ? Center(
              child: TextButton(
                onPressed: () async {
                  await webProvider.getLastThreeMonthsSoapActions();
                },
                child: const Text("Carregar requisições"),
              ),
            )
          : Column(
              children: [
                Text(
                  "Total de clientes: ${webProvider.clientsNames.length}",
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  )
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      // childAspectRatio: 0.7,
                    ),
                    shrinkWrap: true,
                    itemCount: webProvider.clientsNames.length,
                    itemBuilder: (context, index) {
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
                                  onPressed: () {},
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
            ),
    );
  }
}
