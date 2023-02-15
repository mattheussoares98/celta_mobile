import 'package:celta_inventario/Components/Global_widgets/show_error_message.dart';
import 'package:flutter/material.dart';

import '../../Models/sale_request_models/sale_request_products_model.dart';

class SaleRequestAssociatedStocksWidget {
  static saleRequestAssociatedStocksWidget({
    required BuildContext context,
    required SaleRequestProductsModel product,
    required bool hasAssociatedsStock,
  }) {
    return InkWell(
      child: Row(
        children: [
          Text(
            "Estoque",
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
        if (!hasAssociatedsStock) {
          ShowErrorMessage.showErrorMessage(
            error:
                "Esse produto não possui endereço de estoque ou estoque associado à outras empresas",
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
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: product.StockByEnterpriseAssociateds.length,
                    itemBuilder: (
                      BuildContext context,
                      int index,
                    ) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  child: Row(
                                    children: [
                                      Text(
                                        "Endereço na empresa atual: ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2,
                                      ),
                                      Text(
                                        product.StorageAreaAddress == ""
                                            ? "não há"
                                            : product.StorageAreaAddress,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Divider(
                                  height: 3,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          if (index == 0 &&
                              product.StockByEnterpriseAssociateds.length > 1)
                            Column(
                              children: [
                                const SizedBox(
                                  height: 40,
                                ),
                                const FittedBox(
                                  child: Text(
                                    "Estoque nas empresas associadas",
                                    style: TextStyle(
                                      color: Colors.black,
                                      letterSpacing: 0.3,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      fontFamily: "BebasNeue",
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          Column(
                            children: [
                              const Divider(
                                height: 2,
                                color: Colors.black,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              FittedBox(
                                child: Row(
                                  children: [
                                    Text(
                                      "Empresa: ",
                                      style:
                                          Theme.of(context).textTheme.headline2,
                                    ),
                                    Text(
                                      product.StockByEnterpriseAssociateds[
                                          index]["Enterprise"],
                                    ),
                                  ],
                                ),
                              ),
                              FittedBox(
                                child: Row(
                                  children: [
                                    Text(
                                      "Estoque de venda: ",
                                      style:
                                          Theme.of(context).textTheme.headline2,
                                    ),
                                    Text(
                                      product
                                          .StockByEnterpriseAssociateds[index]
                                              ["StockBalanceForSale"]
                                          .toStringAsFixed(3)
                                          .replaceAll(RegExp(r'\.'), ','),
                                    ),
                                  ],
                                ),
                              ),
                              FittedBox(
                                child: Row(
                                  children: [
                                    Text(
                                      "Endereços: ",
                                      style:
                                          Theme.of(context).textTheme.headline2,
                                    ),
                                    Text(
                                      product.StockByEnterpriseAssociateds[
                                                      index]
                                                  ["StorageAreaAddress"] ==
                                              null
                                          ? "Não há"
                                          : product
                                              .StockByEnterpriseAssociateds[
                                                  index]["StorageAreaAddress"]
                                              .toString()
                                              .replaceAll(RegExp(r'\['), '- ')
                                              .replaceAll(RegExp(r'\]'), '')
                                              .replaceAll(
                                                  RegExp(r'\, '), '\n- '),
                                    ),
                                  ],
                                ),
                              ),
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
