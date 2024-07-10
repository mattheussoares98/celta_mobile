import 'package:flutter/material.dart';

import '../../../models/firebase/firebase.dart';

class MonthDetails extends StatelessWidget {
  final SoapActionsModel? monthData;
  const MonthDetails({
    required this.monthData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return monthData == null
        ? const SizedBox()
        : Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (monthData?.adjustStockConfirmQuantity != null)
                    Text(
                        "adjustStockConfirmQuantity: ${monthData?.adjustStockConfirmQuantity}"),
                  if (monthData?.priceConferenceGetProductOrSendToPrint != null)
                    Text(
                        "priceConferenceGetProductOrSendToPrint: ${monthData?.priceConferenceGetProductOrSendToPrint}"),
                  if (monthData?.inventoryEntryQuantity != null)
                    Text(
                        "inventoryEntryQuantity: ${monthData?.inventoryEntryQuantity}"),
                  if (monthData?.receiptEntryQuantity != null)
                    Text(
                        "receiptEntryQuantity: ${monthData?.receiptEntryQuantity}"),
                  if (monthData?.receiptLiberate != null)
                    Text("receiptLiberate: ${monthData?.receiptLiberate}"),
                  if (monthData?.saleRequestSave != null)
                    Text("saleRequestSave: ${monthData?.saleRequestSave}"),
                  if (monthData?.transferBetweenStocksConfirmAdjust != null)
                    Text(
                        "transferBetweenStocksConfirmAdjust: ${monthData?.transferBetweenStocksConfirmAdjust}"),
                  if (monthData?.transferBetweenPackageConfirmAdjust != null)
                    Text(
                        "transferBetweenPackageConfirmAdjust: ${monthData?.transferBetweenPackageConfirmAdjust}"),
                  if (monthData?.transferRequestSave != null)
                    Text(
                        "transferRequestSave: ${monthData?.transferRequestSave}"),
                  if (monthData?.customerRegister != null)
                    Text("customerRegister: ${monthData?.customerRegister}"),
                  if (monthData?.buyRequestSave != null)
                    Text("buyRequestSave: ${monthData?.buyRequestSave}"),
                  if (monthData?.researchPricesInsertPrice != null)
                    Text(
                        "researchPricesInsertPrice: ${monthData?.researchPricesInsertPrice}"),
                  if (monthData != null && monthData?.users != null)
                    for (var i = 0; i < monthData!.users!.length; i++)
                      Text(monthData!.users![i].toString()),
                  if (monthData != null && monthData!.datesUsed != null)
                    for (var i = 0; i < monthData!.datesUsed!.length; i++)
                      Text(monthData!.datesUsed![i].toString()),
                ],
              ),
            ),
          );
  }
}
