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
        title: Text("Total clientes: ${webProvider.clientsNames.length}"),
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
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: webProvider.clientsNames.length,
              itemBuilder: (context, index) {
                final clientName = webProvider.clientsNames[index];

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text((index + 1).toString()),
                            Text(clientName),
                            // Text(webProvider.getTotalRequests(index).toString()),
                          ],
                        ),
                        Text(
                            "Mês atual: ${webProvider.getTotalRequestsByMonth(clientName: clientName, monthSoapActions: webProvider.atualMonth)}"),
                        Text(
                            "Mês passado: ${webProvider.getTotalRequestsByMonth(clientName: clientName, monthSoapActions: webProvider.penultimateMonth)}"),
                        Text(
                            "Mês retrasado: ${webProvider.getTotalRequestsByMonth(clientName: clientName, monthSoapActions: webProvider.antiPenultimateMonth)}"),
                        Text(
                            "Últimos 3 meses: ${webProvider.getTotalRequestsByLastThreeMonths(clientName)}")
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
