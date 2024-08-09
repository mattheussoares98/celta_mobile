import 'package:flutter/material.dart';

import '../../models/soap/soap.dart';
import '../components.dart';

class OpenDialogProductInformations extends StatefulWidget {
  final GetProductJsonModel product;
  const OpenDialogProductInformations({
    required this.product,
    Key? key,
  }) : super(key: key);

  @override
  State<OpenDialogProductInformations> createState() =>
      _OpenDialogProductInformationsState();
}

class _OpenDialogProductInformationsState
    extends State<OpenDialogProductInformations> {
  final PageController _pageController = PageController(initialPage: 0);

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
            "Mais informações",
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
                      Costs(product: widget.product),
                      Stocks(product: widget.product),
                      StockAddress(product: widget.product),
                      LastBuyEntrance(product: widget.product),
                    ],
                  ),
                ),
                actions: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ActionButton(
                            pageIndex: 0,
                            pageController: _pageController,
                            textButton: "Custos",
                          ),
                          const SizedBox(width: 3),
                          ActionButton(
                            pageIndex: 1,
                            pageController: _pageController,
                            textButton: "Estoques",
                          ),
                          const SizedBox(width: 3),
                          ActionButton(
                            pageIndex: 2,
                            pageController: _pageController,
                            textButton: "Endereços",
                          ),
                          const SizedBox(width: 3),
                          ActionButton(
                            pageIndex: 3,
                            pageController: _pageController,
                            textButton: "Compra",
                          ),
                        ],
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
                ],
              );
            });
      },
    );
  }
}
