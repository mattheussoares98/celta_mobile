import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../providers/providers.dart';
import 'components.dart';

class AdjustStockProductsItems extends StatefulWidget {
  final int enterpriseCode;
  final TextEditingController consultedProductController;
  final GlobalKey<FormState> dropDownFormKey;
  final GlobalKey<FormState> insertQuantityFormKey;
  final Function getProductWithCamera;
  const AdjustStockProductsItems({
    required this.enterpriseCode,
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

  void changeFocusToConsultedProductFocusNode({
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

  void selectIndexAndFocus({
    required AdjustStockProvider adjustStockProvider,
    required int index,
  }) {
    widget.consultedProductController.text = "";

    if (adjustStockProvider.productsCount == 1 ||
        adjustStockProvider.isLoadingProducts ||
        adjustStockProvider.isLoadingAdjustStock) {
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
    } else if (_selectedIndex == index) {
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

  @override
  Widget build(BuildContext context) {
    AdjustStockProvider adjustStockProvider = Provider.of(context);

    return Column(
      mainAxisAlignment: adjustStockProvider.productsCount > 1
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: adjustStockProvider.productsCount,
            itemBuilder: (context, index) {
              if (adjustStockProvider.productsCount == 1) {
                _selectedIndex = index;
              }

              final product = adjustStockProvider.products[index];

              return GestureDetector(
                onTap:
                    adjustStockProvider.isLoadingTypeStockAndJustifications ||
                            adjustStockProvider.isLoadingAdjustStock
                        ? null
                        : () {
                            adjustStockProvider
                                    .jsonAdjustStock["ProductPackingCode"] =
                                product.productPackingCode.toString();
                            adjustStockProvider.jsonAdjustStock["ProductCode"] =
                                product.productCode.toString();

                            selectIndexAndFocus(
                              adjustStockProvider: adjustStockProvider,
                              index: index,
                            );
                          },
                child: ProductItem(
                  enterpriseCode: widget.enterpriseCode,
                  product: product,
                  showCosts: false,
                  showLastBuyEntrance: false,
                  showPrice: false,
                  showWholeInformations: false,
                  componentAfterProductInformations: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            _selectedIndex == index
                                ? Icons.arrow_drop_up_sharp
                                : Icons.arrow_drop_down_sharp,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        ],
                      ),
                      if (adjustStockProvider.lastUpdatedQuantity != "" &&
                          adjustStockProvider
                                  .indexOfLastProductChangedStockQuantity ==
                              index)
                        FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "Última quantidade confirmada: ${adjustStockProvider.lastUpdatedQuantity}",
                              style: TextStyle(
                                fontSize: 25,
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
                          consultedProductController:
                              widget.consultedProductController,
                          dropDownFormKey: widget.dropDownFormKey,
                          insertQuantityFormKey: widget.insertQuantityFormKey,
                          internalEnterpriseCode: widget.enterpriseCode,
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
              );
            }),
      ],
    );
  }
}
