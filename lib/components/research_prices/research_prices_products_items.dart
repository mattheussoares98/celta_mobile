import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/sale_request/sale_request.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';
import '../global_widgets/global_widgets.dart';

class ResearchPricesProductsItems extends StatefulWidget {
  final TextEditingController consultedProductController;
  final Function getProductsWithCamera;
  final bool isAssociatedProducts;

  const ResearchPricesProductsItems({
    required this.getProductsWithCamera,
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
  int _selectedIndex = -1;

  changeCursorToLastIndex() {
    widget.consultedProductController.selection = TextSelection.collapsed(
      offset: widget.consultedProductController.text.length,
    );
  }

  changeFocusToConsultedProductFocusNode({
    required SaleRequestProvider saleRequestProvider,
  }) {
    Future.delayed(const Duration(milliseconds: 300), () {
      FocusScope.of(context).requestFocus(
        saleRequestProvider.consultedProductFocusNode,
      );
    });
  }

  selectIndexAndFocus({
    required SaleRequestProvider saleRequestProvider,
    required int index,
    required SaleRequestProductsModel product,
  }) {
    widget.consultedProductController.text = "";

    if (product.RetailPracticedPrice == 0 && product.WholePracticedPrice == 0) {
      ShowSnackbarMessage.showMessage(
        message:
            "O preço de venda e atacado estão zerados! Utilize esse produto somente caso esteja utilizando modelo de pedido de vendas que utiliza o custo como preço!",
        context: context,
        backgroundColor: Theme.of(context).colorScheme.primary,
        secondsDuration: 7,
      );
      setState(() {
        _selectedIndex = index;
        changeFocusToConsultedProductFocusNode(
          saleRequestProvider: saleRequestProvider,
        );
      });

      return;
    }

    if (saleRequestProvider.productsCount == 1 ||
        saleRequestProvider.isLoadingProducts) {
      return;
    }

    if (kIsWeb) {
      if (_selectedIndex != index) {
        setState(() {
          _selectedIndex = index;
          changeFocusToConsultedProductFocusNode(
            saleRequestProvider: saleRequestProvider,
          );
        });
      } else {
        setState(() {
          _selectedIndex = -1;
        });
      }
      return;
    }

    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      if (saleRequestProvider.consultedProductFocusNode.hasFocus &&
          MediaQuery.of(context).viewInsets.bottom == 0) {
        FocusScope.of(context).unfocus();
        changeFocusToConsultedProductFocusNode(
          saleRequestProvider: saleRequestProvider,
        );
      }
      if (!saleRequestProvider.consultedProductFocusNode.hasFocus) {
        changeFocusToConsultedProductFocusNode(
          saleRequestProvider: saleRequestProvider,
        );
      }
      return;
    }

    if (_selectedIndex == index) {
      if (!saleRequestProvider.consultedProductFocusNode.hasFocus) {
        changeFocusToConsultedProductFocusNode(
          saleRequestProvider: saleRequestProvider,
        );
      } else {
        setState(() {
          _selectedIndex = -1;
        });
      }
    }
  }

  Widget itemOfList({
    required int index,
    required ConfigurationsProvider configurationsProvider,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {},
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ConfigurationsProvider configurationsProvider = Provider.of(
      context,
      listen: true,
    );
    ResearchPricesProvider researchPricesProvider = Provider.of(
      context,
      listen: true,
    );

    int itensPerLine = ResponsiveItems.getItensPerLine(context);
    int productsCount = 5;

    return Expanded(
      child: Column(
        // mainAxisAlignment: saleRequestProvider.productsCount > 1
        //     ? MainAxisAlignment.center
        //     : MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.isAssociatedProducts
                  ? researchPricesProvider.associatedsProductsCount
                  : researchPricesProvider.notAssociatedProductsCount,
              itemBuilder: (context, index) {
                // if (saleRequestProvider.productsCount == 1) {
                _selectedIndex = index;
                // }

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
                          configurationsProvider: configurationsProvider,
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
