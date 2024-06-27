import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/buy_request/buy_request.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';
import 'products.dart';

class ProductsItems extends StatefulWidget {
  final bool showOnlyCartProducts;
  const ProductsItems({
    this.showOnlyCartProducts = false,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductsItems> createState() =>
      _ProductsItemsState();
}

class _ProductsItemsState extends State<ProductsItems> {
  void _updatePriceControllerText(BuyRequestProvider buyRequestProvider) {
    BuyRequestProductsModel product;
    if (widget.showOnlyCartProducts) {
      product = buyRequestProvider
          .productsInCart[buyRequestProvider.indexOfSelectedProduct];
    } else {
      product = buyRequestProvider
          .products[buyRequestProvider.indexOfSelectedProduct];
    }
    setState(() {
      buyRequestProvider.priceController.text =
          ConvertString.convertToBrazilianNumber(
        practicedValue(product),
        decimalHouses: 2,
      );

      buyRequestProvider.priceController.text = buyRequestProvider
          .priceController.text
          .replaceAll(RegExp(r'\.'), ',');
    });
  }

  _changeFocusToSelectedProduct(BuyRequestProvider buyRequestProvider) {
    Future.delayed(const Duration(milliseconds: 300), () {
      FocusScope.of(context).requestFocus(
        buyRequestProvider.quantityFocusNode,
      );
    });
  }

  changeFocusAndUpdatePriceControllerText(
    BuyRequestProvider buyRequestProvider,
  ) {
    _updatePriceControllerText(buyRequestProvider);
    _changeFocusToSelectedProduct(buyRequestProvider);
  }

  void selectIndexAndFocus({
    required BuyRequestProvider buyRequestProvider,
    required int index,
  }) {
    buyRequestProvider.quantityController.text = "";
    buyRequestProvider.priceController.text = "";

    if (buyRequestProvider.isLoadingProducts ||
        buyRequestProvider.isLoadingInsertBuyRequest) {
      return;
    }

    if (kIsWeb) {
      if (buyRequestProvider.indexOfSelectedProduct != index) {
        buyRequestProvider.indexOfSelectedProduct = index;
        changeFocusAndUpdatePriceControllerText(buyRequestProvider);
      } else {
        buyRequestProvider.indexOfSelectedProduct = -1;
      }
      return;
    }

    if (buyRequestProvider.indexOfSelectedProduct != index) {
      buyRequestProvider.indexOfSelectedProduct = index;

      if ((buyRequestProvider.quantityFocusNode.hasFocus ||
              buyRequestProvider.priceFocusNode.hasFocus) &&
          MediaQuery.of(context).viewInsets.bottom == 0) {
        FocusScope.of(context).unfocus();
        changeFocusAndUpdatePriceControllerText(buyRequestProvider);
      }
      if (!buyRequestProvider.quantityFocusNode.hasFocus &&
          !buyRequestProvider.priceFocusNode.hasFocus) {
        changeFocusAndUpdatePriceControllerText(buyRequestProvider);
      }
      return;
    }

    if (buyRequestProvider.indexOfSelectedProduct == index) {
      if (!buyRequestProvider.quantityFocusNode.hasFocus &&
          !buyRequestProvider.priceFocusNode.hasFocus) {
        changeFocusAndUpdatePriceControllerText(buyRequestProvider);
      } else {
        buyRequestProvider.indexOfSelectedProduct = -1;
      }
    }
  }

  String practicedValue(BuyRequestProductsModel product) {
    if (product.ValueTyped != 0) {
      return product.ValueTyped.toString();
    } else if (product.Value == 0.0) {
      return product.RealCost.toString();
    } else {
      return product.Value.toString();
    }
  }

  Widget itemOfList({
    required BuyRequestProvider buyRequestProvider,
    required int index,
  }) {
    late BuyRequestProductsModel product;

    if (widget.showOnlyCartProducts) {
      product = buyRequestProvider.productsInCart[index];
    } else {
      product = buyRequestProvider.products[index];
    }

    return InkWell(
      focusColor: Colors.white.withOpacity(0),
      hoverColor: Colors.white.withOpacity(0),
      splashColor: Colors.white.withOpacity(0),
      highlightColor: Colors.white.withOpacity(0),
      onTap: buyRequestProvider.isLoadingProducts ||
              buyRequestProvider.isLoadingInsertBuyRequest
          ? null
          : () {
              setState(() {
                selectIndexAndFocus(
                  buyRequestProvider: buyRequestProvider,
                  index: index,
                );
              });
            },
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProductsInformations(
                    buyRequestProvider: buyRequestProvider,
                    index: index,
                    product: product,
                    practicedValue: practicedValue(product),
                  ),
                  if (buyRequestProvider.indexOfSelectedProduct == index)
                    InsertProductQuantity(
                      product: product,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context);
    int itensPerLine = ResponsiveItems.getItensPerLine(context);
    int productsCount = widget.showOnlyCartProducts
        ? buyRequestProvider.productsInCartCount
        : buyRequestProvider.productsCount;

    return Column(
      mainAxisAlignment: buyRequestProvider.productsCount > 1 ||
              (widget.showOnlyCartProducts &&
                  buyRequestProvider.productsInCartCount > 1)
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.showOnlyCartProducts
              ? buyRequestProvider.productsInCartCount
              : buyRequestProvider.productsCount,
          itemBuilder: (context, index) {
            if (buyRequestProvider.productsCount == 1 &&
                !widget.showOnlyCartProducts) {
              buyRequestProvider.indexOfSelectedProduct = index;
              buyRequestProvider.priceController.text =
                  practicedValue(buyRequestProvider.products[index]);
            } else if (buyRequestProvider.productsCount == 0 &&
                !widget.showOnlyCartProducts) {
              buyRequestProvider.indexOfSelectedProduct = -1;
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
                      buyRequestProvider: buyRequestProvider,
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
