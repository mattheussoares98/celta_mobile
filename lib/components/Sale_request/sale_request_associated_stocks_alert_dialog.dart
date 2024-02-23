import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../global_widgets/global_widgets.dart';

class SaleRequestAssociatedStocksWidget {
  static saleRequestAssociatedStocksWidget({
    required dynamic productModel,
    required bool hasAssociatedsStock,
    required bool hasStocks,
    required BuildContext context,
    required int stockByEnterpriseAssociatedsLength,
    required int stocksLength,
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
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  'Estoques',
                  textAlign: TextAlign.center,
                ),
                content: DefaultTabController(
                  length: 2, // Número de abas
                  child: Column(
                    children: [
                      const TabBar(
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        labelColor: Colors.black,
                        tabs: [
                          Tab(
                            child: Text(
                              "Estoques na empresa",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Estoques associados",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            // border: Border.all(
                            //   // color: Theme.of(context).colorScheme.primary,
                            //   width: 1.0,
                            // ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TabBarView(
                              children: [
                                // Conteúdo da Aba 1
                                !hasStocks
                                    ? const Center(
                                        child: Text(
                                          'Não foram encontradas informações de estoque. Caso acredite que isso está errado, entre em contato com o suporte técnico',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: productModel.Stocks.length,
                                        itemBuilder: (
                                          BuildContext context,
                                          int index,
                                        ) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                children: [
                                                  if (index != 0)
                                                    const Divider(
                                                      height: 2,
                                                      color: Colors.black,
                                                    ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  TitleAndSubtitle
                                                      .titleAndSubtitle(
                                                          title: productModel
                                                                  .Stocks[index]
                                                              ["StockName"],
                                                          value: ConvertString
                                                              .convertToBrazilianNumber(
                                                            productModel
                                                                .Stocks[index][
                                                                    "StockQuantity"]
                                                                .toStringAsFixed(
                                                                    3)
                                                                .replaceAll(
                                                                    RegExp(
                                                                        r'\.'),
                                                                    ','),
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

                                // Conteúdo da Aba 2
                                !hasAssociatedsStock
                                    ? const Center(
                                        child: Text(
                                          'Não foram encontradas informações de estoques associados. Caso acredite que isso está errado, entre em contato com o suporte técnico',
                                        ),
                                      )
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount:
                                              stockByEnterpriseAssociatedsLength,
                                          itemBuilder: (
                                            BuildContext context,
                                            int index,
                                          ) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (index == 0)
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      FittedBox(
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "Endereço na empresa atual: ",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .displayMedium,
                                                            ),
                                                            Text(
                                                              productModel.StorageAreaAddress ==
                                                                          "" ||
                                                                      productModel
                                                                              .StorageAreaAddress ==
                                                                          null
                                                                  ? "não há"
                                                                  : productModel
                                                                      .StorageAreaAddress,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      const Divider(
                                                        height: 3,
                                                        color: Colors.grey,
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                    ],
                                                  ),
                                                if (index == 0 &&
                                                    productModel
                                                            .StockByEnterpriseAssociateds
                                                            .length >
                                                        1)
                                                  const Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 40,
                                                      ),
                                                      FittedBox(
                                                        child: Text(
                                                          "Estoque nas empresas associadas",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            letterSpacing: 0.3,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 30,
                                                            fontFamily:
                                                                "BebasNeue",
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
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
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .displayMedium,
                                                          ),
                                                          Text(
                                                            productModel.StockByEnterpriseAssociateds[
                                                                        index][
                                                                    "Enterprise"] ??
                                                                "",
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    FittedBox(
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "Estoque de venda: ",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .displayMedium,
                                                          ),
                                                          Text(
                                                            productModel
                                                                    .StockByEnterpriseAssociateds[
                                                                        index][
                                                                        "StockBalanceForSale"]
                                                                    .toStringAsFixed(
                                                                        3)
                                                                    .replaceAll(
                                                                        RegExp(
                                                                            r'\.'),
                                                                        ',') ??
                                                                "",
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    FittedBox(
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "Endereços: ",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .displayMedium,
                                                          ),
                                                          Text(
                                                            productModel.StockByEnterpriseAssociateds[index]
                                                                            [
                                                                            "StorageAreaAddress"] ==
                                                                        null ||
                                                                    productModel.StockByEnterpriseAssociateds[index]
                                                                            [
                                                                            "StorageAreaAddress"] ==
                                                                        ""
                                                                ? "Não há"
                                                                : productModel
                                                                    .StockByEnterpriseAssociateds[
                                                                        index][
                                                                        "StorageAreaAddress"]
                                                                    .toString()
                                                                    .replaceAll(
                                                                        RegExp(
                                                                            r'\['),
                                                                        '- ')
                                                                    .replaceAll(
                                                                        RegExp(
                                                                            r'\]'),
                                                                        '')
                                                                    .replaceAll(
                                                                        RegExp(
                                                                            r'\, '),
                                                                        '\n- '),
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Fechar'),
                      ),
                    ],
                  ),
                ],
              );
            });
      },
    );
  }
}
