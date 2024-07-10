import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import 'global_widgets.dart';

class ShowAllStocksWidget extends StatefulWidget {
  final dynamic productModel;
  final bool hasAssociatedsStock;
  final bool hasStocks;
  final BuildContext context;
  final int stockByEnterpriseAssociatedsLength;
  final int stocksLength;
  final bool isLoading;
  final double fontSize;
  final double iconSize;
  const ShowAllStocksWidget({
    required this.productModel,
    required this.hasAssociatedsStock,
    required this.hasStocks,
    required this.context,
    required this.stockByEnterpriseAssociatedsLength,
    required this.stocksLength,
    this.isLoading = false,
    this.fontSize = 20,
    this.iconSize = 30,
    Key? key,
  }) : super(key: key);

  @override
  State<ShowAllStocksWidget> createState() => _ShowAllStocksWidgetState();
}

class _ShowAllStocksWidgetState extends State<ShowAllStocksWidget> {
  final PageController _pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return InkWell(
          focusColor: Colors.white.withOpacity(0),
          hoverColor: Colors.white.withOpacity(0),
          splashColor: Colors.white.withOpacity(0),
          highlightColor: Colors.white.withOpacity(0),
      child: Row(
        children: [
          Text(
            "Estoque",
            style: TextStyle(
              color: widget.isLoading
                  ? Colors.grey
                  : Theme.of(context).colorScheme.primary,
              fontSize: widget.fontSize,
            ),
          ),
          const SizedBox(width: 3),
          Icon(
            Icons.info,
            size: widget.iconSize,
            color: widget.isLoading
                ? Colors.grey
                : Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
      onTap: widget.isLoading
          ? null
          : () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: MediaQuery.of(context).size.height * 0.95,
                        child: PageView(
                          controller: _pageController,
                          children: [
                            enterpriseStocks(
                              hasStocks: widget.hasStocks,
                              productModel: widget.productModel,
                              context: context,
                            ),
                            associatedStocks(
                              hasAssociatedsStock: widget.hasAssociatedsStock,
                              stockByEnterpriseAssociatedsLength:
                                  widget.stockByEnterpriseAssociatedsLength,
                              productModel: widget.productModel,
                              context: context,
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease,
                                  );
                                },
                                child: const Column(
                                  children: [
                                    Text(
                                      'Estoque na',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'empresa',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease,
                                  );
                                },
                                child: const Column(
                                  children: [
                                    Text(
                                      'Estoques',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'associados',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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

Widget enterpriseStocks({
  required bool hasStocks,
  required productModel,
  required BuildContext context,
}) {
  return !hasStocks
      ? const Center(
          child: Text(
            'Não foram encontradas informações de estoque. Caso acredite que isso está errado, entre em contato com o suporte técnico',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        )
      : Column(
          children: [
            Text(
              "Estoques na empresa",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: "Bebasneue",
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: productModel.Stocks.length,
                itemBuilder: (
                  BuildContext context,
                  int index,
                ) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                              title: productModel.Stocks[index]["StockName"],
                              subtitle: ConvertString.convertToBrazilianNumber(
                                productModel.Stocks[index]["StockQuantity"]
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
          ],
        );
}

Widget associatedStocks({
  required BuildContext context,
  required bool hasAssociatedsStock,
  required int stockByEnterpriseAssociatedsLength,
  required productModel,
}) {
  return !hasAssociatedsStock
      ? const Center(
          child: Text(
            'Não foram encontradas informações de estoques associados. Caso acredite que isso está errado, entre em contato com o suporte técnico',
          ),
        )
      : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Estoques nas empresas associadas",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: "Bebasneue",
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: stockByEnterpriseAssociatedsLength,
                itemBuilder: (
                  BuildContext context,
                  int index,
                ) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (index == 0)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FittedBox(
                              child: Row(
                                children: [
                                  Text(
                                    "Endereço na empresa atual: ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  ),
                                  Text(
                                    productModel.StorageAreaAddress == "" ||
                                            productModel.StorageAreaAddress ==
                                                null
                                        ? "não há"
                                        : productModel.StorageAreaAddress,
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
                          productModel.StockByEnterpriseAssociateds.length > 1)
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  fontFamily: "BebasNeue",
                                ),
                                textAlign: TextAlign.center,
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
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                ),
                                Text(
                                  productModel.StockByEnterpriseAssociateds[
                                          index]["Enterprise"] ??
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
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                ),
                                Text(
                                  productModel
                                          .StockByEnterpriseAssociateds[index]
                                              ["StockBalanceForSale"]
                                          .toStringAsFixed(3)
                                          .replaceAll(RegExp(r'\.'), ',') ??
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
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                ),
                                Text(
                                  productModel.StockByEnterpriseAssociateds[
                                                      index]
                                                  ["StorageAreaAddress"] ==
                                              null ||
                                          productModel.StockByEnterpriseAssociateds[
                                                      index]
                                                  ["StorageAreaAddress"] ==
                                              ""
                                      ? "Não há"
                                      : productModel
                                          .StockByEnterpriseAssociateds[index]
                                              ["StorageAreaAddress"]
                                          .toString()
                                          .replaceAll(RegExp(r'\['), '- ')
                                          .replaceAll(RegExp(r'\]'), '')
                                          .replaceAll(RegExp(r'\, '), '\n- '),
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
        );
}
