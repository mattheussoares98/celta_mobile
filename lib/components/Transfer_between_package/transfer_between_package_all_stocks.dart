import 'package:celta_inventario/Components/Global_widgets/show_error_message.dart';
import 'package:celta_inventario/Components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/Models/transfer_between_package_models/transfer_between_package_product_model.dart';
import 'package:celta_inventario/utils/convert_string.dart';
import 'package:flutter/material.dart';

class TransferBetweenPackageAllStocks {
  static transferBetweenPackageAllStocks({
    required BuildContext context,
    required bool hasStocks,
    required TransferBetweenPackageProductModel product,
    required bool isLoading,
  }) {
    return InkWell(
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
                ShowErrorMessage.showErrorMessage(
                  error:
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
