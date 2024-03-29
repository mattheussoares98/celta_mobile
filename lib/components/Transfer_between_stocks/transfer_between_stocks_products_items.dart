import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/transfer_between_stocks/transfer_between_stocks.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';
import '../global_widgets/global_widgets.dart';
import 'transfer_between_stocks.dart';

class TransferBetweenStocksProductsItems extends StatefulWidget {
  final int internalEnterpriseCode;
  final TextEditingController consultedProductController;
  final GlobalKey<FormState> dropDownFormKey;
  final GlobalKey<FormState> insertQuantityFormKey;
  final Function getProductsWithCamera;
  const TransferBetweenStocksProductsItems({
    required this.getProductsWithCamera,
    required this.internalEnterpriseCode,
    required this.consultedProductController,
    required this.dropDownFormKey,
    required this.insertQuantityFormKey,
    Key? key,
  }) : super(key: key);

  @override
  State<TransferBetweenStocksProductsItems> createState() =>
      _TransferBetweenStocksProductsItemsState();
}

class _TransferBetweenStocksProductsItemsState
    extends State<TransferBetweenStocksProductsItems> {
  int _selectedIndex = -1;

  changeFocusToConsultedProductFocusNode({
    required TransferBetweenStocksProvider transferBetweenStocksProvider,
  }) {
    Future.delayed(const Duration(milliseconds: 300), () {
      //se não colocar em um future pra mudar o foco,
      //não funciona corretamente
      FocusScope.of(context).requestFocus(
        transferBetweenStocksProvider.consultedProductFocusNode,
      );
    });
  }

  selectIndexAndFocus({
    required TransferBetweenStocksProvider transferBetweenStocksProvider,
    required int index,
  }) {
    widget.consultedProductController.text = "";

    if (transferBetweenStocksProvider.productsCount == 1 ||
        transferBetweenStocksProvider.isLoadingProducts ||
        transferBetweenStocksProvider.isLoadingAdjustStock) {
      return;
    }

    if (kIsWeb) {
      if (_selectedIndex != index) {
        setState(() {
          _selectedIndex = index;
          changeFocusToConsultedProductFocusNode(
            transferBetweenStocksProvider: transferBetweenStocksProvider,
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

      if (transferBetweenStocksProvider.consultedProductFocusNode.hasFocus &&
          MediaQuery.of(context).viewInsets.bottom == 0) {
        FocusScope.of(context).unfocus();
        changeFocusToConsultedProductFocusNode(
          transferBetweenStocksProvider: transferBetweenStocksProvider,
        );
      }
      if (!transferBetweenStocksProvider.consultedProductFocusNode.hasFocus) {
        changeFocusToConsultedProductFocusNode(
          transferBetweenStocksProvider: transferBetweenStocksProvider,
        );
      }
      return;
    }

    if (_selectedIndex == index) {
      if (!transferBetweenStocksProvider.consultedProductFocusNode.hasFocus) {
        changeFocusToConsultedProductFocusNode(
          transferBetweenStocksProvider: transferBetweenStocksProvider,
        );
      } else {
        setState(() {
          _selectedIndex = -1;
        });
      }
    }
  }

  Widget itemOfList({
    required TransferBetweenStocksProvider transferBetweenStocksProvider,
    required int index,
  }) {
    TransferBetweenStocksProductModel product =
        transferBetweenStocksProvider.products[index];
    return InkWell(
          focusColor: Colors.white.withOpacity(0),
          hoverColor: Colors.white.withOpacity(0),
          splashColor: Colors.white.withOpacity(0),
          highlightColor: Colors.white.withOpacity(0),
      onTap: transferBetweenStocksProvider
                  .isLoadingTypeStockAndJustifications ||
              transferBetweenStocksProvider.isLoadingAdjustStock
          ? null
          : () {
              transferBetweenStocksProvider
                      .jsonAdjustStock["ProductPackingCode"] =
                  product.ProductPackingCode;
              transferBetweenStocksProvider.jsonAdjustStock["ProductCode"] =
                  product.ProductCode;
              selectIndexAndFocus(
                transferBetweenStocksProvider: transferBetweenStocksProvider,
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
                otherWidget: TransferBetweenStocksAllStocks
                    .transferBetweenStocksAllStocks(
                  context: context,
                  hasStocks: product.Stocks.length > 0,
                  product: product,
                  isLoading: transferBetweenStocksProvider.isLoadingAdjustStock,
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
              if (transferBetweenStocksProvider.lastUpdatedQuantity != "" &&
                  // transferBetweenStocksProvider
                  //         .indexOfLastProductChangedStockQuantity !=
                  //     -1 &&
                  transferBetweenStocksProvider
                          .indexOfLastProductChangedStockQuantity ==
                      index)
                FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Última quantidade confirmada: ${transferBetweenStocksProvider.lastUpdatedQuantity}",
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
                TransferBetweenStocksInsertQuantity(
                  consultedProductController: widget.consultedProductController,
                  dropDownFormKey: widget.dropDownFormKey,
                  insertQuantityFormKey: widget.insertQuantityFormKey,
                  internalEnterpriseCode: widget.internalEnterpriseCode,
                  index: index,
                  getProductsWithCamera: widget.getProductsWithCamera,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TransferBetweenStocksProvider transferBetweenStocksProvider =
        Provider.of(context);
    int itensPerLine = ResponsiveItems.getItensPerLine(context);
    int productsCount = transferBetweenStocksProvider.productsCount;

    return Column(
      mainAxisAlignment: transferBetweenStocksProvider.productsCount > 1
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: productsCount,
          itemBuilder: (context, index) {
            if (transferBetweenStocksProvider.productsCount == 1) {
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
                      transferBetweenStocksProvider:
                          transferBetweenStocksProvider,
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
