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
    final enterprises = _getEnterpriseNames(product.stocks);

    return product.stocks == null || product.stocks?.isEmpty == true
        ? const Center(
            child: Text("Não há estoques para esse produto"),
          )
        : ListView.builder(
          shrinkWrap: true,
          itemCount: enterprises.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return const Padding(
                padding: EdgeInsets.only(bottom: 10),
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
        
            final enterprise = enterprises[index - 1];
        
            final stocksByEnterprise = product.stocks!
                .where((e) => e.enterprise == enterprise)
                .toList();
        
            return ListView.builder(
              shrinkWrap: true,
              itemCount: stocksByEnterprise.length + 1,
              itemBuilder: (context, stockIndex) {
                if (stockIndex == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          enterprise,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                }
        
                final stock = stocksByEnterprise[stockIndex - 1];
        
                return TitleAndSubtitle.titleAndSubtitle(
                  title: stock.stockName,
                  subtitle:
                      stock.stockQuantity.toString().toBrazilianNumber(3),
                  subtitleColor: _stockColor(
                    stockQuantity: stock.stockQuantity.toString(),
                    context: context,
                  ),
                );
              },
            );
          },
        );
  }
}

List<String> _getEnterpriseNames(List<StocksModel>? stocks) {
  List<String> names = [];
  if (stocks == null) {
    return names;
  }

  for (var stock in stocks) {
    if (!names.contains(stock.enterprise) && stock.enterprise != null) {
      names.add(stock.enterprise!);
    }
  }
  return names;
}

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
