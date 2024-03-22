import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../global_widgets/global_widgets.dart';
import '../../components/research_prices/research_prices.dart';
import '../../models/research_prices/research_prices.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';

class ResearchPricesProductsItems extends StatefulWidget {
  final TextEditingController consultedProductController;
  final bool isAssociatedProducts;

  const ResearchPricesProductsItems({
    required this.consultedProductController,
    required this.isAssociatedProducts,
    Key? key,
  }) : super(key: key);

  @override
  State<ResearchPricesProductsItems> createState() =>
      _ResearchPricesProductsItemsState();
}

class _ResearchPricesProductsItemsState
    extends State<ResearchPricesProductsItems> {
  int _selectedIndexAssociatedProducts = -1;
  int _selectedIndexNotAssociatedProducts = -1;

  _updateSelectedIndex(int index) {
    if (widget.isAssociatedProducts) {
      if (_selectedIndexAssociatedProducts == index) {
        setState(() {
          _selectedIndexAssociatedProducts = -1;
        });
      } else {
        setState(() {
          _selectedIndexAssociatedProducts = index;
        });
      }
    } else {
      if (_selectedIndexNotAssociatedProducts == index) {
        setState(() {
          _selectedIndexNotAssociatedProducts = -1;
        });
      } else {
        setState(() {
          _selectedIndexNotAssociatedProducts = index;
        });
      }
    }
  }

  String textButtonMessage(int index) {
    if (widget.isAssociatedProducts) {
      return _selectedIndexAssociatedProducts != index
          ? "Inserir preços"
          : "Minimizar preços";
    } else {
      return _selectedIndexNotAssociatedProducts != index
          ? "Inserir preços"
          : "Minimizar preços";
    }
  }

  IconData iconType(int index) {
    if (widget.isAssociatedProducts) {
      return _selectedIndexAssociatedProducts == index
          ? Icons.arrow_drop_up_sharp
          : Icons.arrow_drop_down;
    } else {
      return _selectedIndexNotAssociatedProducts == index
          ? Icons.arrow_drop_up_sharp
          : Icons.arrow_drop_down;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedIndexAssociatedProducts = -1;
    _selectedIndexNotAssociatedProducts = -1;
  }

  Widget itemOfList({
    required int index,
    required ResearchPricesProvider researchPricesProvider,
  }) {
    ResearchPricesProductsModel product = widget.isAssociatedProducts
        ? researchPricesProvider.associatedsProducts[index]
        : researchPricesProvider.notAssociatedProducts[index];
    final researchPricesInsertPrices = ResearchPricesInsertPrices(
      product: product,
      showErrorMessage: () {
        ShowSnackbarMessage.showMessage(
          message: researchPricesProvider.errorInsertConcurrentPrices,
          context: context,
        );
      },
      showSuccessMessage: () {
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
              value: product.ProductName,
            ),
            TitleAndSubtitle.titleAndSubtitle(
              title: "PLU",
              value: product.PriceLookUp.toString(),
              otherWidget: TextButton(
                onPressed: () {
                  _updateSelectedIndex(index);
                },
                child: Row(
                  children: [
                    Text(
                      textButtonMessage(index),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Icon(
                      _selectedIndexAssociatedProducts == index
                          ? Icons.arrow_drop_up_sharp
                          : Icons.arrow_drop_down,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
            if (widget.isAssociatedProducts &&
                _selectedIndexAssociatedProducts == index)
              researchPricesInsertPrices,
            if (!widget.isAssociatedProducts &&
                _selectedIndexNotAssociatedProducts == index)
              researchPricesInsertPrices,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResearchPricesProvider researchPricesProvider = Provider.of(
      context,
      listen: true,
    );

    int itensPerLine = ResponsiveItems.getItensPerLine(context);
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
                  _selectedIndexAssociatedProducts = index;
                } else if (productsCount == 1 && !widget.isAssociatedProducts) {
                  _selectedIndexNotAssociatedProducts = index;
                }

                final startIndex = index * itensPerLine;
                final endIndex = (startIndex + itensPerLine <= productsCount)
                    ? startIndex + itensPerLine
                    : productsCount;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = startIndex; i < endIndex; i++)
                      Expanded(
                        child: itemOfList(
                          index: i,
                          researchPricesProvider: researchPricesProvider,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
