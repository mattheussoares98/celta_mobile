import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../components/global_widgets/global_widgets.dart';
import '../../../models/price_conference/price_conference.dart';

Color _stockColor({
  required String stockQuantity,
  required BuildContext context,
}) {
  final quantity = double.tryParse(stockQuantity);

  if (quantity == null) {
    return Colors.black;
  } else if (quantity < 0) {
    return Colors.red;
  } else if (quantity == 0) {
    return Colors.black;
  } else {
    return Theme.of(context).colorScheme.primary;
  }
}

Widget stocks({
  required BuildContext context,
  required PriceConferenceProductsModel product,
}) =>
    product.stocks == null || product.stocks?.isEmpty == true
        ? const Center(
            child: Text("Não há estoques para esse produto"),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: product.stocks!.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: Text(
                    "ESTOQUES",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              final stock = product.stocks![index - 1];

              return TitleAndSubtitle.titleAndSubtitle(
                title: stock.StockName,
                value: stock.StockQuantity.toBrazilianNumber(3),
                subtitleColor: _stockColor(
                  stockQuantity: stock.StockQuantity,
                  context: context,
                ),
              );
            },
          );
