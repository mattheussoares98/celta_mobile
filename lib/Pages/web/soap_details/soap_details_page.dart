import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../Models/firebase/firebase.dart';
import '../../../providers/providers.dart';
import 'month_details.dart';

class SoapDetailsPage extends StatelessWidget {
  const SoapDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    String enterpriseName =
        ModalRoute.of(context)!.settings.arguments as String;
    WebProvider webProvider = Provider.of(context);

    SoapActionsModel? atualMonthData;
    if (webProvider.dataFromLastTrheeMonths[Months.AtualMonth.name] != null) {
      final data = webProvider.dataFromLastTrheeMonths[Months.AtualMonth.name]!
          .where((element) => element.documentId == enterpriseName);

      if (data.isNotEmpty) {
        atualMonthData = data.first;
      }
    }
    SoapActionsModel? penultimateMonth;
    if (webProvider.dataFromLastTrheeMonths[Months.PenultimateMonth.name] !=
        null) {
      final data = webProvider
          .dataFromLastTrheeMonths[Months.PenultimateMonth.name]!
          .where((element) => element.documentId == enterpriseName);

      if (data.isNotEmpty) {
        penultimateMonth = data.first;
      }
    }
    SoapActionsModel? antiPenultimateMonth;
    if (webProvider.dataFromLastTrheeMonths[Months.AntiPenultimateMonth.name] !=
        null) {
      final data = webProvider
          .dataFromLastTrheeMonths[Months.AntiPenultimateMonth.name]!
          .where((element) => element.documentId == enterpriseName);

      if (data.isNotEmpty) {
        antiPenultimateMonth = data.first;
      }
    }

    final SoapActionsModel lastThreeMonthsMergeds =
        webProvider.mergeLastThreeMonths(enterpriseName);

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(child: Text("Total de requisições ($enterpriseName)")),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              MonthDetails(
                monthData: atualMonthData,
                month: webProvider.yearAndMonthFromLastTrheeMonths()[0],
              ),
              MonthDetails(
                monthData: penultimateMonth,
                month: webProvider.yearAndMonthFromLastTrheeMonths()[1],
              ),
              MonthDetails(
                monthData: antiPenultimateMonth,
                month: webProvider.yearAndMonthFromLastTrheeMonths()[2],
              ),
              Column(
                children: [
                  MonthDetails(
                    monthData: lastThreeMonthsMergeds,
                    month: "Total nos últimos 3 meses",
                    showUsersAndDatesInformations: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
