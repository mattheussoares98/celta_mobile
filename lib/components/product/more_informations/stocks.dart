import 'package:flutter/material.dart';

import '../../components.dart';
import '../../../models/soap/products/products.dart';
import '../../../utils/utils.dart';

class Stocks extends StatelessWidget implements MoreInformationWidget {
  @override
  MoreInformationType get type => MoreInformationType.stocks;
  @override
  String get moreInformationName => "Estoques";

  final GetProductJsonModel product;
  const Stocks({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return product.stocks == null || product.stocks?.isEmpty == true
        ? const Center(
            child: Text("Não há estoques para esse produto"),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: product.stocks!.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "ESTOQUES",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              }
              final stock = product.stocks![index - 1];

              return TitleAndSubtitle.titleAndSubtitle(
                title: stock.stockName,
                subtitle: stock.stockQuantity.toString().toBrazilianNumber(3),
                subtitleColor: _stockColor(
                  stockQuantity: stock.stockQuantity.toString(),
                  context: context,
                ),
              );
            },
          );
  }
}

Widget stocks({
  required BuildContext context,
  required GetProductJsonModel product,
}) =>
    product.stocks == null || product.stocks?.isEmpty == true
        ? const Center(
            child: Text("Não há estoques para esse produto"),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: product.stocks!.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const Column(
                  children: [
                    Divider(),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "ESTOQUES",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              }
              final stock = product.stocks![index - 1];

              return TitleAndSubtitle.titleAndSubtitle(
                title: stock.stockName,
                subtitle: stock.stockQuantity.toString().toBrazilianNumber(3),
                subtitleColor: _stockColor(
                  stockQuantity: stock.stockQuantity.toString(),
                  context: context,
                ),
              );
            },
          );

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
