import 'package:celta_inventario/Models/buy_request_models/buy_request_product_model.dart';
import 'package:celta_inventario/components/Buy_request/buy_request_insert_product_quantity.dart';
import 'package:celta_inventario/components/Global_widgets/show_alert_dialog.dart';
import 'package:celta_inventario/components/Global_widgets/show_all_stocks.dart';
import 'package:celta_inventario/providers/buy_request_provider.dart';
import 'package:celta_inventario/utils/convert_string.dart';
import 'package:celta_inventario/utils/responsive_items.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Global_widgets/title_and_value.dart';

class BuyRequestProductsItems extends StatefulWidget {
  final bool showOnlyCartProducts;
  const BuyRequestProductsItems({
    this.showOnlyCartProducts = false,
    Key? key,
  }) : super(key: key);

  @override
  State<BuyRequestProductsItems> createState() =>
      _BuyRequestProductsItemsState();
}

class _BuyRequestProductsItemsState extends State<BuyRequestProductsItems> {
  changeFocusToSelectedProductFocusNode() {
    BuyRequestProvider buyRequestProvider = Provider.of(context, listen: false);
    Future.delayed(const Duration(milliseconds: 300), () {
      //se não colocar em um future pra mudar o foco,
      //não funciona corretamente
      FocusScope.of(context).requestFocus(
        buyRequestProvider.quantityFocusNode,
      );
    });
  }

  selectIndexAndFocus({
    required BuyRequestProvider buyRequestProvider,
    required int index,
  }) {
    buyRequestProvider.quantityController.text = "";
    buyRequestProvider.priceController.text = "";

    if (buyRequestProvider.isLoadingProducts) {
      return;
    }

    if (kIsWeb) {
      if (buyRequestProvider.indexOfSelectedProduct != index) {
        setState(() {
          buyRequestProvider.indexOfSelectedProduct = index;
          changeFocusToSelectedProductFocusNode();
        });
      } else {
        setState(() {
          buyRequestProvider.indexOfSelectedProduct = -1;
        });
      }
      return;
    }

    if (buyRequestProvider.indexOfSelectedProduct != index) {
      setState(() {
        buyRequestProvider.indexOfSelectedProduct = index;
      });

      if (buyRequestProvider.quantityFocusNode.hasFocus &&
          MediaQuery.of(context).viewInsets.bottom == 0) {
        FocusScope.of(context).unfocus();
        changeFocusToSelectedProductFocusNode();
      }
      if (!buyRequestProvider.quantityFocusNode.hasFocus) {
        changeFocusToSelectedProductFocusNode();
      }
      return;
    }

    if (buyRequestProvider.indexOfSelectedProduct == index) {
      if (!buyRequestProvider.quantityFocusNode.hasFocus) {
        changeFocusToSelectedProductFocusNode();
      } else {
        setState(() {
          buyRequestProvider.indexOfSelectedProduct = -1;
        });
      }
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
      onTap: buyRequestProvider.isLoadingProducts ||
              buyRequestProvider.isLoadingInsertBuyRequest
          ? null
          : () {
              selectIndexAndFocus(
                buyRequestProvider: buyRequestProvider,
                index: index,
              );
            },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TitleAndSubtitle.titleAndSubtitle(
                fontSize: 15,
                title: "PLU",
                value: product.PLU,
                otherWidget: ShowAllStocksWidget(
                  isLoading: buyRequestProvider.isLoadingInsertBuyRequest,
                  productModel: product,
                  hasAssociatedsStock: product.StorageAreaAddress != null &&
                      product.StockByEnterpriseAssociateds != null,
                  hasStocks: product.Stocks != null,
                  context: context,
                  stockByEnterpriseAssociatedsLength:
                      product.StockByEnterpriseAssociateds?.length ?? 0,
                  stocksLength: product.Stocks?.length ?? 0,
                  fontSize: 15,
                  iconSize: 25,
                ),
              ),
              TitleAndSubtitle.titleAndSubtitle(
                fontSize: 15,
                title: "Nome",
                value: product.Name,
              ),
              TitleAndSubtitle.titleAndSubtitle(
                fontSize: 15,
                title: "Empresa",
                value: product.EnterpriseCode.toString(),
              ),
              TitleAndSubtitle.titleAndSubtitle(
                fontSize: 15,
                title: "Embalagem",
                value: product.PackingQuantity,
                otherWidget: InkWell(
                  onTap: buyRequestProvider.isLoadingInsertBuyRequest
                      ? null
                      : () {
                          ShowAlertDialog.showAlertDialog(
                            context: context,
                            title: "Remover produto",
                            subtitle: "Remover produto do carrinho?",
                            function: () {
                              buyRequestProvider.removeProductFromCart(product);
                            },
                          );
                        },
                  child: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 25,
                  ),
                ),
              ),
              TitleAndSubtitle.titleAndSubtitle(
                fontSize: 15,
                title: "Preço",
                value: ConvertString.convertToBRL(product.Value),
                subtitleColor: product.Value == 0 ? Colors.red : Colors.green,
                otherWidget: product.quantity > 0
                    ? null
                    : Icon(
                        buyRequestProvider.indexOfSelectedProduct != index
                            ? Icons.arrow_drop_down_sharp
                            : Icons.arrow_drop_up_sharp,
                        color: Theme.of(context).colorScheme.primary,
                        size: 30,
                      ),
              ),
              if (product.quantity > 0)
                Column(
                  children: [
                    TitleAndSubtitle.titleAndSubtitle(
                      fontSize: 15,
                      title: "Quantidade",
                      value: ConvertString.convertToBrazilianNumber(
                          product.quantity),
                      subtitleColor: Theme.of(context).colorScheme.primary,
                    ),
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "Total",
                      fontSize: 15,
                      value: ConvertString.convertToBRL(
                        product.Value * product.quantity,
                      ),
                      subtitleColor: Theme.of(context).colorScheme.primary,
                      otherWidget: product.quantity == 0
                          ? null
                          : Icon(
                              buyRequestProvider.indexOfSelectedProduct != index
                                  ? Icons.arrow_drop_down_sharp
                                  : Icons.arrow_drop_up_sharp,
                              color: Theme.of(context).colorScheme.primary,
                              size: 30,
                            ),
                    ),
                  ],
                ),
              if (buyRequestProvider.indexOfSelectedProduct == index)
                BuyRequestInsertProductQuantity(
                  insertQuantityFormKey:
                      buyRequestProvider.insertQuantityFormKey,
                  priceController: buyRequestProvider.priceController,
                  quantityController: buyRequestProvider.quantityController,
                  product: product,
                ),
            ],
          ),
        ),
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
