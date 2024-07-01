import 'package:flutter/material.dart';

import '../../../components/global_widgets/global_widgets.dart';
import '../../../models/products/products.dart';
import '../../../utils/utils.dart';

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
  required GetProductCmxJson product,
}) =>
    product.Stocks.isEmpty
        ? const Center(
            child: Text("Não há estoques para esse produto"),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: product.Stocks.length + 1,
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
              final stock = product.Stocks[index - 1];

              return TitleAndSubtitle.titleAndSubtitle(
                title: stock.StockName,
                value: stock.StockQuantity.toString().toBrazilianNumber(3),
                subtitleColor: _stockColor(
                  stockQuantity: stock.StockQuantity.toString(),
                  context: context,
                ),
              );
            },
          );
