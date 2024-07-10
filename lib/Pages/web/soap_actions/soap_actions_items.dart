import 'package:celta_inventario/utils/utils.dart';
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
        Text("Total de clientes: ${webProvider.enterprisesNames.length}",
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            )),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 500 ? 5 : 2,
              // childAspectRatio: 0.7,
            ),
            shrinkWrap: true,
            itemCount: webProvider.enterprisesNames.toList().length,
            itemBuilder: (_, index) {
              final enterpriseName =
                  webProvider.enterprisesNames.toList()[index];

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              enterpriseName.toUpperCase(),
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
                              ], clientName: enterpriseName)}",
                        ),
                        Text(
                          "Mês passado: ${webProvider.getTotalSoapActions(months: [
                                Months.PenultimateMonth
                              ], clientName: enterpriseName)}",
                        ),
                        Text(
                          "Mês atual: ${webProvider.getTotalSoapActions(months: [
                                Months.AtualMonth
                              ], clientName: enterpriseName)}",
                        ),
                        Text(
                          "Últimos 3 meses: ${webProvider.getTotalSoapActions(months: [
                                Months.AtualMonth,
                                Months.PenultimateMonth,
                                Months.AntiPenultimateMonth,
                              ], clientName: enterpriseName)}",
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              APPROUTES.WEB_SOAP_DETAILS,
                              arguments: enterpriseName,
                            );
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
