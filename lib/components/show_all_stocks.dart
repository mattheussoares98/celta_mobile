import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../models/soap/soap.dart';
import 'components.dart';

class ShowAllStocksWidget extends StatefulWidget {
  final GetProductJsonModel productModel;
  final BuildContext context;
  final bool isLoading;
  final double fontSize;
  final double iconSize;
  const ShowAllStocksWidget({
    required this.productModel,
    required this.context,
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
    return GestureDetector(
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
                              productModel: widget.productModel,
                              context: context,
                            ),
                            associatedStocks(
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
  required GetProductJsonModel productModel,
  required BuildContext context,
}) {
  return productModel.stocks?.isEmpty == true
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
              "Estoques",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: "Bebasneue",
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: productModel.stocks!.length,
                itemBuilder: (
                  BuildContext context,
                  int index,
                ) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleAndSubtitle.titleAndSubtitle(
                            title: productModel.stocks![index].stockName,
                            subtitle: ConvertString.convertToBrazilianNumber(
                              productModel.stocks![index].stockQuantity ??
                                  0
                                      .toStringAsFixed(3)
                                      .replaceAll(RegExp(r'\.'), ','),
                            )),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
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

  return Column(
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
                    style: Theme.of(context).textTheme.displayMedium,
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
        Expanded(
          child: Column(
            children: [
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
              Expanded(
                child: ListView.builder(
                  itemCount: productModel.stockByEnterpriseAssociateds!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Empresa: ',
                                style:
                                    Theme.of(context).textTheme.displayMedium,
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
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              Text(
                                (productModel
                                            .stockByEnterpriseAssociateds![
                                                index]
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
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              Text(
                                productModel
                                            .stockByEnterpriseAssociateds![
                                                index]
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
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
    ],
  );
}
