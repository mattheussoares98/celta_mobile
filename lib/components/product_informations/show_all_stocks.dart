import 'package:flutter/material.dart';

import '../../models/soap/soap.dart';
import '../components.dart';

class ShowAllStocksWidget extends StatefulWidget {
  final GetProductJsonModel productModel;
  const ShowAllStocksWidget({
    required this.productModel,
    Key? key,
  }) : super(key: key);

  @override
  State<ShowAllStocksWidget> createState() => _ShowAllStocksWidgetState();
}

class _ShowAllStocksWidgetState extends State<ShowAllStocksWidget> {
  final PageController _pageController = PageController(initialPage: 0);

  Widget selectTypeStockButton({
    required String textButton,
    required bool isAdvancePage,
  }) {
    return FittedBox(
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          textStyle: const TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: () {
          if (isAdvancePage) {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          } else {
            _pageController.previousPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          }
        },
        child: FittedBox(
          child: Text(
            textButton,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        children: [
          Text(
            "Estoque",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 3),
          Icon(
            Icons.info,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                contentPadding: const EdgeInsets.all(8),
                insetPadding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 10,
                ),
                actionsPadding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 8,
                ),
                content: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: PageView(
                    controller: _pageController,
                    children: [
                      Stocks(product: widget.productModel),
                      associatedStocks(
                        productModel: widget.productModel,
                        context: context,
                      ),
                    ],
                  ),
                ),
                actions: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: selectTypeStockButton(
                          textButton: "Estoques",
                          isAdvancePage: false,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Column(
                          children: [
                            selectTypeStockButton(
                              textButton: "Endereços",
                              isAdvancePage: true,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Fechar",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
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

Widget associatedStocks({
  required BuildContext context,
  required GetProductJsonModel productModel,
}) {
  bool _hasAreaAdressInAtualEnterprise() {
    return productModel.storageAreaAddress?.isNotEmpty == true &&
        productModel.storageAreaAddress!.length > 0;
  }

  bool _hasAssociatedStocks() {
    return productModel.stockByEnterpriseAssociateds?.isNotEmpty == true &&
        productModel.stockByEnterpriseAssociateds!.length > 1;
  }

  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Endereço dos estoques",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: "Bebasneue",
          ),
          textAlign: TextAlign.center,
        ),
        if (!_hasAreaAdressInAtualEnterprise())
          const Text(
            'Não foram encontradas informações de endereço de estoque na empresa atual',
            textAlign: TextAlign.center,
          ),
        if (_hasAreaAdressInAtualEnterprise())
          Column(
            children: [
              FittedBox(
                child: Row(
                  children: [
                    Text(
                      "Endereço na empresa atual: ",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      productModel.storageAreaAddress!,
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 20,
                color: Colors.grey,
              ),
            ],
          ),
        if (!_hasAssociatedStocks())
          const Center(
            child: Text(
              'Não foram encontradas informações de estoques associados. Caso acredite que isso está errado, entre em contato com o suporte técnico',
            ),
          ),
        if (_hasAssociatedStocks())
          Column(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Divider(
                    height: 20,
                    color: Colors.grey,
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
                ],
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: productModel.stockByEnterpriseAssociateds!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Empresa: ',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            TextSpan(
                              text: productModel
                                  .stockByEnterpriseAssociateds![index]
                                  .enterprise,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            Text(
                              "Estoque de venda: ",
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            Text(
                              (productModel.stockByEnterpriseAssociateds![index]
                                          .stockBalanceForSale ??
                                      0)
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
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            Text(
                              productModel.stockByEnterpriseAssociateds![index]
                                          .storageAreaAddress ==
                                      null
                                  ? "Não há"
                                  : productModel
                                      .stockByEnterpriseAssociateds![index]
                                      .storageAreaAddress
                                      .toString()
                                      .replaceAll(RegExp(r'\['), '- ')
                                      .replaceAll(RegExp(r'\]'), '')
                                      .replaceAll(RegExp(r'\, '), '\n- '),
                            ),
                          ],
                        ),
                      ),
                      if (index + 1 <
                          productModel.stockByEnterpriseAssociateds!.length)
                        const Divider()
                    ],
                  );
                },
              ),
            ],
          ),
      ],
    ),
  );
}
