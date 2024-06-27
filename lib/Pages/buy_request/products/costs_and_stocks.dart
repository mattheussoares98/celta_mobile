import 'package:flutter/material.dart';

import '../../../models/buy_request/buy_request.dart';
import '../../../utils/utils.dart';
import '../../../components/global_widgets/global_widgets.dart';

class CostsAndStocks extends StatefulWidget {
  final BuyRequestProductsModel product;
  final BuildContext context;
  final bool isLoading;

  const CostsAndStocks({
    required this.product,
    required this.context,
    required this.isLoading,
    Key? key,
  }) : super(key: key);

  @override
  State<CostsAndStocks> createState() =>
      _CostsAndStocksState();
}

class _CostsAndStocksState extends State<CostsAndStocks> {
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
            "Estoques e custos",
            style: TextStyle(
              color: widget.isLoading
                  ? Colors.grey
                  : Theme.of(context).colorScheme.primary,
              fontSize: 17,
            ),
          ),
          const SizedBox(width: 3),
          Icon(
            Icons.info,
            size: 25,
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
                            productModel: widget.product,
                            context: context,
                          ),
                          costs(context: context, product: widget.product),
                        ],
                      ),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StockInEnterpriseButton(
                              pageController: _pageController),
                          const SizedBox(width: 5),
                          CostsButton(pageController: _pageController),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
    );
  }
}

class CostsButton extends StatelessWidget {
  const CostsButton({
    Key? key,
    required PageController pageController,
  })  : _pageController = pageController,
        super(key: key);

  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
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
              'Custos',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StockInEnterpriseButton extends StatelessWidget {
  const StockInEnterpriseButton({
    Key? key,
    required PageController pageController,
  })  : _pageController = pageController,
        super(key: key);

  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
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
              'Estoque',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget enterpriseStocks({
  required BuyRequestProductsModel productModel,
  required BuildContext context,
}) {
  return productModel.Stocks == null
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
                itemCount: productModel.Stocks!.length,
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
                              title: productModel.Stocks![index]["StockName"],
                              value: ConvertString.convertToBrazilianNumber(
                                productModel.Stocks?[index]["StockQuantity"]
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

Widget costs({
  required BuildContext context,
  required BuyRequestProductsModel product,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        "Custos",
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Reposição",
                  value: ConvertString.convertToBRL(product.ReplacementCost),
                ),
                const SizedBox(height: 10),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Reposição médio",
                  value:
                      ConvertString.convertToBRL(product.ReplacementCostMidle),
                ),
                const SizedBox(height: 10),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Fiscal",
                  value: ConvertString.convertToBRL(product.FiscalCost),
                ),
                const SizedBox(height: 10),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Fiscal líquido",
                  value: ConvertString.convertToBRL(product.FiscalLiquidCost),
                ),
                const SizedBox(height: 10),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Líquido",
                  value: ConvertString.convertToBRL(product.LiquidCost),
                ),
                const SizedBox(height: 10),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Líquido médio",
                  value: ConvertString.convertToBRL(product.LiquidCostMidle),
                ),
                const SizedBox(height: 10),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Operacional",
                  value: ConvertString.convertToBRL(product.OperationalCost),
                ),
                const SizedBox(height: 10),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Real",
                  value: ConvertString.convertToBRL(product.RealCost),
                ),
                const SizedBox(height: 10),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Real líquido",
                  value: ConvertString.convertToBRL(product.RealLiquidCost),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
