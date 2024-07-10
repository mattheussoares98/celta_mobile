import 'package:celta_inventario/pages/web/soap_details/month_details.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../models/firebase/firebase.dart';
import '../../../providers/providers.dart';

class SoapDetailsPage extends StatelessWidget {
  const SoapDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    String enterpriseName =
        ModalRoute.of(context)!.settings.arguments as String;
    WebProvider webProvider = Provider.of(context);
    SoapActionsModel? atualMonthData;

    if (webProvider.dataFromLastTrheeMonths[Months.AtualMonth.name] != null) {
      atualMonthData = webProvider
          .dataFromLastTrheeMonths[Months.AtualMonth.name]!
          .where((element) => element.documentId == enterpriseName)
          .first;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(enterpriseName),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              webProvider.yearAndMonthFromLastTrheeMonths()[0],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            MonthDetails(monthData: atualMonthData),
          ],
        ),
      ),
    );
  }
}
