import 'package:celta_inventario/Models/buy_request_models/buy_request_product_model.dart';
import 'package:celta_inventario/components/Buy_request/buy_request_insert_product_quantity.dart';
import 'package:celta_inventario/components/Global_widgets/show_all_stocks.dart';
import 'package:celta_inventario/providers/buy_request_provider.dart';
import 'package:celta_inventario/utils/responsive_items.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Global_widgets/title_and_value.dart';

class BuyRequestProductsItems extends StatefulWidget {
  final int internalEnterpriseCode;
  final TextEditingController consultedProductController;
  final FocusNode consultedProductFocusNode;
  final GlobalKey<FormState> insertQuantityFormKey;
  final Function getProductWithCamera;
  const BuyRequestProductsItems({
    required this.internalEnterpriseCode,
    required this.getProductWithCamera,
    required this.consultedProductController,
    required this.insertQuantityFormKey,
    required this.consultedProductFocusNode,
    Key? key,
  }) : super(key: key);

  @override
  State<BuyRequestProductsItems> createState() =>
      _BuyRequestProductsItemsState();
}

class _BuyRequestProductsItemsState extends State<BuyRequestProductsItems> {
  int _selectedIndex = -1;

  changeFocusToConsultedProductFocusNode({
    required BuyRequestProvider buyRequestProvider,
  }) {
    Future.delayed(const Duration(milliseconds: 300), () {
      //se não colocar em um future pra mudar o foco,
      //não funciona corretamente
      FocusScope.of(context).requestFocus(
        widget.consultedProductFocusNode,
      );
    });
  }

  selectIndexAndFocus({
    required BuyRequestProvider buyRequestProvider,
    required int index,
  }) {
    widget.consultedProductController.text = "";

    if (buyRequestProvider.productsCount == 1 ||
        buyRequestProvider.isLoadingProducts) {
      return;
    }

    if (kIsWeb) {
      if (_selectedIndex != index) {
        setState(() {
          _selectedIndex = index;
          changeFocusToConsultedProductFocusNode(
            buyRequestProvider: buyRequestProvider,
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

      if (widget.consultedProductFocusNode.hasFocus &&
          MediaQuery.of(context).viewInsets.bottom == 0) {
        FocusScope.of(context).unfocus();
        changeFocusToConsultedProductFocusNode(
          buyRequestProvider: buyRequestProvider,
        );
      }
      if (!widget.consultedProductFocusNode.hasFocus) {
        changeFocusToConsultedProductFocusNode(
          buyRequestProvider: buyRequestProvider,
        );
      }
      return;
    }

    if (_selectedIndex == index) {
      if (!widget.consultedProductFocusNode.hasFocus) {
        changeFocusToConsultedProductFocusNode(
          buyRequestProvider: buyRequestProvider,
        );
      } else {
        setState(() {
          _selectedIndex = -1;
        });
      }
    }
  }

  Widget itemOfList({
    required BuyRequestProvider buyRequestProvider,
    required int index,
  }) {
    BuyRequestProductsModel product = buyRequestProvider.products[index];

    return InkWell(
      onTap: buyRequestProvider.isLoadingProducts
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
                title: "Nome",
                value: product.Name,
              ),
              TitleAndSubtitle.titleAndSubtitle(
                title: "PLU",
                value: product.PLU,
                otherWidget: ShowAllStocksWidget(
                  productModel: product,
                  hasAssociatedsStock: product.StorageAreaAddress != "" ||
                      product.StockByEnterpriseAssociateds != null,
                  hasStocks: product.Stocks != null,
                  context: context,
                  stockByEnterpriseAssociatedsLength:
                      product.StockByEnterpriseAssociateds?.length ?? 0,
                  stocksLength: product.Stocks?.length ?? 0,
                ),
              ),
              TitleAndSubtitle.titleAndSubtitle(
                title: "Embalagem",
                value: product.PackingQuantity,
              ),
              if (_selectedIndex == index)
                BuyRequestInsertProductQuantity(
                  internalEnterpriseCode: product.EnterpriseCode,
                  updateSelectedIndex: () {
                    setState(() {
                      _selectedIndex = -1;
                    });
                  },
                  getProductWithCamera: widget.getProductWithCamera,
                  insertQuantityFormKey: widget.insertQuantityFormKey,
                  consultedProductController: widget.consultedProductController,
                  index: index,
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
    int productsCount = buyRequestProvider.productsCount;

    return Column(
      mainAxisAlignment: buyRequestProvider.productsCount > 1
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: buyRequestProvider.productsCount,
          itemBuilder: (context, index) {
            if (buyRequestProvider.productsCount == 1) {
              _selectedIndex = index;
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
