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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (atualMonthData?.adjustStockConfirmQuantity != null)
                      Text(
                          "adjustStockConfirmQuantity: ${atualMonthData?.adjustStockConfirmQuantity}"),
                    if (atualMonthData
                            ?.priceConferenceGetProductOrSendToPrint !=
                        null)
                      Text(
                          "priceConferenceGetProductOrSendToPrint: ${atualMonthData?.priceConferenceGetProductOrSendToPrint}"),
                    if (atualMonthData?.inventoryEntryQuantity != null)
                      Text(
                          "inventoryEntryQuantity: ${atualMonthData?.inventoryEntryQuantity}"),
                    if (atualMonthData?.receiptEntryQuantity != null)
                      Text(
                          "receiptEntryQuantity: ${atualMonthData?.receiptEntryQuantity}"),
                    if (atualMonthData?.receiptLiberate != null)
                      Text(
                          "receiptLiberate: ${atualMonthData?.receiptLiberate}"),
                    if (atualMonthData?.saleRequestSave != null)
                      Text(
                          "saleRequestSave: ${atualMonthData?.saleRequestSave}"),
                    if (atualMonthData?.transferBetweenStocksConfirmAdjust !=
                        null)
                      Text(
                          "transferBetweenStocksConfirmAdjust: ${atualMonthData?.transferBetweenStocksConfirmAdjust}"),
                    if (atualMonthData?.transferBetweenPackageConfirmAdjust !=
                        null)
                      Text(
                          "transferBetweenPackageConfirmAdjust: ${atualMonthData?.transferBetweenPackageConfirmAdjust}"),
                    if (atualMonthData?.transferRequestSave != null)
                      Text(
                          "transferRequestSave: ${atualMonthData?.transferRequestSave}"),
                    if (atualMonthData?.customerRegister != null)
                      Text(
                          "customerRegister: ${atualMonthData?.customerRegister}"),
                    if (atualMonthData?.buyRequestSave != null)
                      Text("buyRequestSave: ${atualMonthData?.buyRequestSave}"),
                    if (atualMonthData?.researchPricesInsertPrice != null)
                      Text(
                          "researchPricesInsertPrice: ${atualMonthData?.researchPricesInsertPrice}"),
                    if (atualMonthData != null && atualMonthData.users != null)
                      for (var i = 0; i < atualMonthData.users!.length; i++)
                        Text(atualMonthData.users![i].toString()),
                    if (atualMonthData != null &&
                        atualMonthData.datesUsed != null)
                      for (var i = 0; i < atualMonthData.datesUsed!.length; i++)
                        Text(atualMonthData.datesUsed![i].toString()),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
