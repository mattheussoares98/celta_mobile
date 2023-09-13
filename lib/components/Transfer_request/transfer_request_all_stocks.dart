import 'package:celta_inventario/Components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/Models/transfer_request/transfer_request_products_model.dart';
import 'package:celta_inventario/components/Global_widgets/show_snackbar_message.dart';
import 'package:celta_inventario/utils/convert_string.dart';
import 'package:flutter/material.dart';

class TransferRequestAllStocks {
  static transferRequestAllStocks({
    required BuildContext context,
    required bool hasStocks,
    required TransferRequestProductsModel product,
  }) {
    return InkWell(
      child: Row(
        children: [
          Text(
            "Estoques",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 20,
            ),
          ),
          const SizedBox(width: 3),
          Icon(
            Icons.info,
            size: 30,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
      onTap: () {
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
                                  title: product.Stocks[index]["StockName"],
                                  value: ConvertString.convertToBrazilianNumber(
                                    product.Stocks[index]["StockQuantity"]
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
