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
                      Stocks(product: widget.product),
                      AssociatedStocks(
                        product: widget.product,
                      ),
                      Costs(product: widget.product),
                    ],
                  ),
                ),
                actions: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: ActionButton(
                          pageIndex: 0,
                          pageController: _pageController,
                          textButton: "Estoques",
                        ),
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Column(
                          children: [
                            ActionButton(
                              pageIndex: 1,
                              pageController: _pageController,
                              textButton: "Endereços",
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
                      const SizedBox(width: 5),
                      Flexible(
                        child: ActionButton(
                          pageIndex: 2,
                          pageController: _pageController,
                          textButton: "Custos",
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
