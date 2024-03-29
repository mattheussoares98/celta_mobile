import 'package:flutter/material.dart';

import '../../models/transfer_between_package/transfer_between_package.dart';
import '../../utils/utils.dart';
import '../global_widgets/global_widgets.dart';

class TransferBetweenPackageAllStocks {
  static transferBetweenPackageAllStocks({
    required BuildContext context,
    required bool hasStocks,
    required TransferBetweenPackageProductModel product,
    required bool isLoading,
  }) {
    return InkWell(
          focusColor: Colors.white.withOpacity(0),
          hoverColor: Colors.white.withOpacity(0),
          splashColor: Colors.white.withOpacity(0),
          highlightColor: Colors.white.withOpacity(0),
      child: Row(
        children: [
          Text(
            "Estoques",
            style: TextStyle(
              color: isLoading
                  ? Colors.grey
                  : Theme.of(context).colorScheme.primary,
              fontSize: 20,
            ),
          ),
          const SizedBox(width: 3),
          Icon(
            Icons.info,
            size: 30,
            color:
                isLoading ? Colors.grey : Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
      onTap: isLoading
          ? null
          : () {
              if (!hasStocks) {
                ShowSnackbarMessage.showMessage(
                  message:
                      "Entre em contato com o suporte técnico e solicite a atualização do sistema para conseguir visualizar todos estoques",
                  context: context,
                );
                return;
              }
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      scrollable: true,
                      content: Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: product.Stocks.length,
                          itemBuilder: (
                            BuildContext context,
                            int index,
                          ) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    const Divider(
                                      height: 2,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TitleAndSubtitle.titleAndSubtitle(
                                        title: product.Stocks[index].StockName,
                                        value: ConvertString
                                            .convertToBrazilianNumber(
                                          product.Stocks[index].StockQuantity
                                              .toStringAsFixed(3)
                                              .replaceAll(RegExp(r'\.'), ','),
                                        )),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  });
            },
    );
  }
}
