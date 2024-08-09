import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import 'components.dart';
import '../../../models/research_prices/research_prices.dart';
import '../../../providers/providers.dart';

class ProductsItems extends StatefulWidget {
  final TextEditingController consultedProductController;
  final bool isAssociatedProducts;

  const ProductsItems({
    required this.consultedProductController,
    required this.isAssociatedProducts,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductsItems> createState() => _ProductsItemsState();
}

class _ProductsItemsState extends State<ProductsItems> {
  _updateSelectedIndex({
    required int index,
    required ResearchPricesProvider researchPricesProvider,
  }) {
    if (widget.isAssociatedProducts) {
      if (researchPricesProvider.selectedIndexAssociatedProducts == index) {
        setState(() {
          researchPricesProvider.selectedIndexAssociatedProducts = -1;
        });
      } else {
        setState(() {
          researchPricesProvider.selectedIndexAssociatedProducts = index;
        });
      }
    } else {
      if (researchPricesProvider.selectedIndexNotAssociatedProducts == index) {
        setState(() {
          researchPricesProvider.selectedIndexNotAssociatedProducts = -1;
        });
      } else {
        setState(() {
          researchPricesProvider.selectedIndexNotAssociatedProducts = index;
        });
      }
    }
  }

  String textButtonMessage({
    required int index,
    required ResearchPricesProvider researchPricesProvider,
  }) {
    if (widget.isAssociatedProducts) {
      return researchPricesProvider.selectedIndexAssociatedProducts != index
          ? "Inserir preços"
          : "Minimizar preços";
    } else {
      return researchPricesProvider.selectedIndexNotAssociatedProducts != index
          ? "Inserir preços"
          : "Minimizar preços";
    }
  }

  IconData iconType({
    required int index,
    required ResearchPricesProvider researchPricesProvider,
  }) {
    if (widget.isAssociatedProducts) {
      return researchPricesProvider.selectedIndexAssociatedProducts == index
          ? Icons.arrow_drop_up_sharp
          : Icons.arrow_drop_down;
    } else {
      return researchPricesProvider.selectedIndexNotAssociatedProducts == index
          ? Icons.arrow_drop_up_sharp
          : Icons.arrow_drop_down;
    }
  }

  @override
  Widget build(BuildContext context) {
    ResearchPricesProvider researchPricesProvider = Provider.of(
      context,
      listen: true,
    );

    int productsCount = widget.isAssociatedProducts
        ? researchPricesProvider.associatedsProductsCount
        : researchPricesProvider.notAssociatedProductsCount;

    return Expanded(
      child: Column(
        mainAxisAlignment: productsCount > 1
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: productsCount,
              itemBuilder: (context, index) {
                if (productsCount == 1 && widget.isAssociatedProducts) {
                  researchPricesProvider.selectedIndexAssociatedProducts =
                      index;
                } else if (productsCount == 1 && !widget.isAssociatedProducts) {
                  researchPricesProvider.selectedIndexNotAssociatedProducts =
                      index;
                }

                ResearchPricesProductsModel product =
                    widget.isAssociatedProducts
                        ? researchPricesProvider.associatedsProducts[index]
                        : researchPricesProvider.notAssociatedProducts[index];
                final researchPricesInsertPrices = InsertPrices(
                  isAssociatedProducts: widget.isAssociatedProducts,
                  product: product,
                  showErrorMessage: () {
                    ShowSnackbarMessage.showMessage(
                      message:
                          researchPricesProvider.errorInsertConcurrentPrices,
                      context: context,
                    );
                  },
                  showSuccessMessage: () {
                    setState(() {
                      widget.isAssociatedProducts
                          ? researchPricesProvider
                              .selectedIndexAssociatedProducts = -1
                          : researchPricesProvider
                              .selectedIndexNotAssociatedProducts = -1;
                    });

                    ShowSnackbarMessage.showMessage(
                      message: "Preços inseridos com sucesso!",
                      context: context,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    );
                  },
                );

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TitleAndSubtitle.titleAndSubtitle(
                          title: "Produto",
                          subtitle: product.ProductName,
                        ),
                        TitleAndSubtitle.titleAndSubtitle(
                          title: "PLU",
                          subtitle: product.PriceLookUp.toString(),
                          otherWidget: TextButton(
                            onPressed: () {
                              _updateSelectedIndex(
                                index: index,
                                researchPricesProvider: researchPricesProvider,
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  textButtonMessage(
                                    index: index,
                                    researchPricesProvider:
                                        researchPricesProvider,
                                  ),
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                Icon(
                                  researchPricesProvider
                                              .selectedIndexAssociatedProducts ==
                                          index
                                      ? Icons.arrow_drop_up_sharp
                                      : Icons.arrow_drop_down,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (widget.isAssociatedProducts &&
                            researchPricesProvider
                                    .selectedIndexAssociatedProducts ==
                                index)
                          researchPricesInsertPrices,
                        if (!widget.isAssociatedProducts &&
                            researchPricesProvider
                                    .selectedIndexNotAssociatedProducts ==
                                index)
                          researchPricesInsertPrices,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
