import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/adjust_stock/adjust_stock.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';
import '../global_widgets/global_widgets.dart';
import './adjust_stock.dart';

class AdjustStockProductsItems extends StatefulWidget {
  final int internalEnterpriseCode;
  final TextEditingController consultedProductController;
  final GlobalKey<FormState> dropDownFormKey;
  final GlobalKey<FormState> insertQuantityFormKey;
  final Function getProductWithCamera;
  const AdjustStockProductsItems({
    required this.internalEnterpriseCode,
    required this.getProductWithCamera,
    required this.consultedProductController,
    required this.dropDownFormKey,
    required this.insertQuantityFormKey,
    Key? key,
  }) : super(key: key);

  @override
  State<AdjustStockProductsItems> createState() =>
      _AdjustStockProductsItemsState();
}

class _AdjustStockProductsItemsState extends State<AdjustStockProductsItems> {
  int _selectedIndex = -1;

  changeFocusToConsultedProductFocusNode({
    required AdjustStockProvider adjustStockProvider,
  }) {
    Future.delayed(const Duration(milliseconds: 300), () {
      //se não colocar em um future pra mudar o foco,
      //não funciona corretamente
      FocusScope.of(context).requestFocus(
        adjustStockProvider.consultedProductFocusNode,
      );
    });
  }

  selectIndexAndFocus({
    required AdjustStockProvider adjustStockProvider,
    required int index,
  }) {
    widget.consultedProductController.text = "";

    if (adjustStockProvider.productsCount == 1 ||
        adjustStockProvider.isLoadingProducts ||
        adjustStockProvider.isLoadingAdjustStock) {
      return;
    }

    if (kIsWeb) {
      if (_selectedIndex != index) {
        setState(() {
          _selectedIndex = index;
          changeFocusToConsultedProductFocusNode(
            adjustStockProvider: adjustStockProvider,
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

      if (adjustStockProvider.consultedProductFocusNode.hasFocus &&
          MediaQuery.of(context).viewInsets.bottom == 0) {
        FocusScope.of(context).unfocus();
        changeFocusToConsultedProductFocusNode(
          adjustStockProvider: adjustStockProvider,
        );
      }
      if (!adjustStockProvider.consultedProductFocusNode.hasFocus) {
        changeFocusToConsultedProductFocusNode(
          adjustStockProvider: adjustStockProvider,
        );
      }
      return;
    }

    if (_selectedIndex == index) {
      if (!adjustStockProvider.consultedProductFocusNode.hasFocus) {
        changeFocusToConsultedProductFocusNode(
          adjustStockProvider: adjustStockProvider,
        );
      } else {
        setState(() {
          _selectedIndex = -1;
        });
      }
    }
  }

  Widget itemOfList({
    required AdjustStockProvider adjustStockProvider,
    required int index,
  }) {
    AdjustStockProductModel product = adjustStockProvider.products[index];

    return InkWell(
      onTap: adjustStockProvider.isLoadingTypeStockAndJustifications ||
              adjustStockProvider.isLoadingAdjustStock
          ? null
          : () {
              adjustStockProvider.jsonAdjustStock["ProductPackingCode"] =
                  product.ProductPackingCode.toString();
              adjustStockProvider.jsonAdjustStock["ProductCode"] =
                  product.ProductCode.toString();

              selectIndexAndFocus(
                adjustStockProvider: adjustStockProvider,
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
                value: product.PriceLookUp,
                otherWidget: AdjustStockAllStocks.adjustStockAllStocks(
                  context: context,
                  hasStocks: product.Stocks.length > 0,
                  product: product,
                  isLoading: adjustStockProvider.isLoadingAdjustStock,
                ),
              ),
              TitleAndSubtitle.titleAndSubtitle(
                title: "Embalagem",
                value: product.PackingQuantity,
              ),
              TitleAndSubtitle.titleAndSubtitle(
                title: "Estoque atual",
                value: ConvertString.convertToBrazilianNumber(
                  product.CurrentStock,
                ),
              ),
              TitleAndSubtitle.titleAndSubtitle(
                title: "Saldo estoque de venda",
                value: ConvertString.convertToBrazilianNumber(
                  product.SaldoEstoqueVenda,
                ),
                otherWidget: Icon(
                  _selectedIndex != index
                      ? Icons.arrow_drop_down_sharp
                      : Icons.arrow_drop_up_sharp,
                  color: Theme.of(context).colorScheme.primary,
                  size: 30,
                ),
              ),
              if (adjustStockProvider.lastUpdatedQuantity != "" &&
                  adjustStockProvider.indexOfLastProductChangedStockQuantity ==
                      index)
                FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Última quantidade confirmada: ${adjustStockProvider.lastUpdatedQuantity}",
                      style: TextStyle(
                        fontSize: 100,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'BebasNeue',
                        fontStyle: FontStyle.italic,
                        letterSpacing: 1,
                        wordSpacing: 4,
                      ),
                    ),
                  ),
                ),
              if (_selectedIndex == index)
                AdjustStockInsertQuantity(
                  consultedProductController: widget.consultedProductController,
                  dropDownFormKey: widget.dropDownFormKey,
                  insertQuantityFormKey: widget.insertQuantityFormKey,
                  internalEnterpriseCode: widget.internalEnterpriseCode,
                  index: index,
                  getProductWithCamera: widget.getProductWithCamera,
                  updateSelectedIndex: () {
                    setState(() {
                      _selectedIndex = -1;
                    });
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AdjustStockProvider adjustStockProvider = Provider.of(context);
    int itensPerLine = ResponsiveItems.getItensPerLine(context);
    int productsCount = adjustStockProvider.productsCount;

    return Expanded(
      child: Column(
        mainAxisAlignment: adjustStockProvider.productsCount > 1
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: adjustStockProvider.productsCount,
              itemBuilder: (context, index) {
                if (adjustStockProvider.productsCount == 1) {
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
                          adjustStockProvider: adjustStockProvider,
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
