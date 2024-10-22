import 'package:celta_inventario/components/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/soap/soap.dart';
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
  State<ProductsItems> createState() => _ProductsItemsState();
}

class _ProductsItemsState extends State<ProductsItems> {
  void _updatePriceControllerText(BuyRequestProvider buyRequestProvider) {
    GetProductJsonModel product;
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
        getPracticedValue(product),
        decimalHouses: 2,
      );

      buyRequestProvider.priceController.text = buyRequestProvider
          .priceController.text
          .replaceAll(RegExp(r'\.'), ',');
    });
  }

  void _changeFocusToSelectedProduct(BuyRequestProvider buyRequestProvider) {
    Future.delayed(const Duration(milliseconds: 300), () {
      FocusScope.of(context).requestFocus(
        buyRequestProvider.quantityFocusNode,
      );
    });
  }

  void changeFocusAndUpdatePriceControllerText(
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

  String getPracticedValue(GetProductJsonModel product) {
    if (product.valueTyped != 0) {
      return product.valueTyped.toString();
    } else if (product.value == 0.0) {
      return product.realCost.toString();
    } else {
      return product.value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context);

    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.showOnlyCartProducts
            ? buyRequestProvider.productsInCartCount
            : buyRequestProvider.productsCount,
        itemBuilder: (context, index) {
          if (buyRequestProvider.productsCount == 1 &&
              !widget.showOnlyCartProducts) {
            buyRequestProvider.indexOfSelectedProduct = index;
            buyRequestProvider.priceController.text =
                getPracticedValue(buyRequestProvider.products[index]);
          } else if (buyRequestProvider.productsCount == 0 &&
              !widget.showOnlyCartProducts) {
            buyRequestProvider.indexOfSelectedProduct = -1;
          }

          final product = widget.showOnlyCartProducts
              ? buyRequestProvider.productsInCart[index]
              : buyRequestProvider.products[index];

          return GestureDetector(
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProductItem(
                  product: product,
                  showWholeInformations: false,
                  showCosts: false,
                  showPrice: false,
                  showLastBuyEntrance: true,
                  componentBeforeProductInformations:
                      TitleAndSubtitle.titleAndSubtitle(
                    fontSize: 20,
                    subtitleColor: Colors.yellow[900],
                    subtitle: _enterprisePersonalizedCodeAndName(
                      buyRequestProvider: buyRequestProvider,
                      product: product,
                    ),
                  ),
                  componentAfterProductInformations: Column(
                    children: [
                      CostsQuantityAndTotal(
                        practicedValue: getPracticedValue(product),
                        product: product,
                        index: index,
                      ),
                      if (buyRequestProvider.indexOfSelectedProduct == index)
                        InsertProductQuantity(
                          product: product,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

String _enterprisePersonalizedCodeAndName({
  required BuyRequestProvider buyRequestProvider,
  required GetProductJsonModel product,
}) {
  var enterprise = buyRequestProvider.enterprises.firstWhere(
    (element) => product.enterpriseCode == element.Code,
  );

  return "(${enterprise.PersonalizedCode}) - " + enterprise.Name;
}
