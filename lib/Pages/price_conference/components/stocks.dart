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
    InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Fechar"),
                  )
                ],
                content: ListView.builder(
                  itemCount: product.stocks.length,
                  itemBuilder: (context, index) {
                    final stock = product.stocks[index];

                    return Column(
                      children: [
                        TitleAndSubtitle.titleAndSubtitle(
                          title: stock.StockName,
                          value: stock.StockQuantity.toBrazilianNumber(3),
                          subtitleColor: _stockColor(
                            stockQuantity: stock.StockQuantity,
                            context: context,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            });
      },
      child: Row(
        children: [
          Icon(
            Icons.info,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            "Estoques",
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
