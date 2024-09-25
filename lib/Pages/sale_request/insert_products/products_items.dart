import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/soap/soap.dart';
import '../../../providers/providers.dart';
import '../../../components/components.dart';
import 'insert_products.dart';

class ProductsItems extends StatefulWidget {
  final TextEditingController consultedProductController;
  final int enterpriseCode;
  final Function getProductsWithCamera;

  const ProductsItems({
    required this.getProductsWithCamera,
    required this.consultedProductController,
    required this.enterpriseCode,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductsItems> createState() => _ProductsItemsState();
}

class _ProductsItemsState extends State<ProductsItems> {
  int _selectedIndex = -1;
  GlobalKey<FormState> _consultedProductFormKey = GlobalKey();
  final _insertQuantityFocusNode = FocusNode();

  changeCursorToLastIndex() {
    widget.consultedProductController.selection = TextSelection.collapsed(
      offset: widget.consultedProductController.text.length,
    );
  }

  bool hasOneProductAndIsExpandedQuantityForm = false;
  //quando só retorna um produto na consulta, já expande a opção de inserção de
  //quantidade dos itens. Esse bool serve para saber quando já foi expandido uma
  //vez automaticamente o campo para digitação da quantidade, senão vai ficar
  //abrindo direto o campo para digitação, mesmo quando já inseriu a quantidade.

  void removeProduct({
    required SaleRequestProvider saleRequestProvider,
    required double totalItemValue,
    required GetProductJsonModel product,
  }) {
    ShowAlertDialog.show(
      context: context,
      title: "Confirmar exclusão",
      subtitle: "Deseja excluir o produto do carrinho?",
      function: () {
        setState(() {
          saleRequestProvider.removeProductFromCart(
            ProductPackingCode: product.productPackingCode!,
            enterpriseCode: widget.enterpriseCode.toString(),
          );

          setState(() {
            totalItemValue = saleRequestProvider.getTotalItemValue(
              product: product,
              consultedProductController: widget.consultedProductController,
              enterpriseCode: widget.enterpriseCode.toString(),
            );
          });
        });
      },
    );
  }

  changeFocusToConsultedProductFocusNode() {
    if (_selectedIndex < 0) return;

    Future.delayed(const Duration(milliseconds: 300), () {
      if (_insertQuantityFocusNode.hasFocus &&
          MediaQuery.of(context).viewInsets.bottom == 0) {
        _insertQuantityFocusNode.unfocus();
      }
      FocusScope.of(context).requestFocus(
        _insertQuantityFocusNode,
      );
    });
  }

  selectIndexAndFocus({
    required SaleRequestProvider saleRequestProvider,
    required int index,
    required GetProductJsonModel product,
  }) {
    widget.consultedProductController.text = "";

    if (saleRequestProvider.productsCount == 1 ||
        saleRequestProvider.isLoadingProducts) {
      return;
    } else if (_selectedIndex == index) {
      setState(() {
        _selectedIndex = -1;
      });
    } else if (product.retailPracticedPrice == 0 &&
        product.wholePracticedPrice == 0) {
      ShowSnackbarMessage.show(
        message:
            "O preço de venda e atacado estão zerados! Utilize esse produto somente caso esteja utilizando modelo de pedido de vendas que utiliza o custo como preço!",
        context: context,
        backgroundColor: Theme.of(context).colorScheme.primary,
        secondsDuration: 4,
      );
      setState(() {
        _selectedIndex = index;
      });
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }

    changeFocusToConsultedProductFocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _insertQuantityFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider = Provider.of(context);
    ConfigurationsProvider configurationsProvider = Provider.of(context);

    if (saleRequestProvider.products.isEmpty) {
      _selectedIndex = -1;
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: saleRequestProvider.productsCount,
      itemBuilder: (context, index) {
        if (saleRequestProvider.productsCount == 1) {
          _selectedIndex = index;
        }
        GetProductJsonModel product = saleRequestProvider.products[index];
        double _totalItensInCart = saleRequestProvider.getTotalItensInCart(
          ProductPackingCode: product.productPackingCode!,
          enterpriseCode: widget.enterpriseCode.toString(),
        );

        double _totalItemValue = saleRequestProvider.getTotalItemValue(
          product: product,
          consultedProductController: widget.consultedProductController,
          enterpriseCode: widget.enterpriseCode.toString(),
        );

        return GestureDetector(
          onTap: saleRequestProvider.isLoadingProducts
              ? null
              : () {
                  selectIndexAndFocus(
                    saleRequestProvider: saleRequestProvider,
                    index: index,
                    product: product,
                  );
                },
          child: ProductItem(
            product: product,
            showCosts: false,
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
                if (saleRequestProvider.alreadyContainsProduct(
                  ProductPackingCode: product.productPackingCode!,
                  enterpriseCode: widget.enterpriseCode.toString(),
                ))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 7,
                        child: Text(
                          "Qtd no carrinho: " +
                              saleRequestProvider
                                  .getTotalItensInCart(
                                    ProductPackingCode:
                                        product.productPackingCode!,
                                    enterpriseCode:
                                        widget.enterpriseCode.toString(),
                                  )
                                  .toStringAsFixed(3)
                                  .replaceAll(RegExp(r'\.'), ','),
                          style: TextStyle(
                            color: _totalItensInCart > 0
                                ? Colors.red
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        flex: 4,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: _totalItensInCart > 0
                              ? () => removeProduct(
                                    saleRequestProvider: saleRequestProvider,
                                    totalItemValue: _totalItemValue,
                                    product: product,
                                  )
                              : null,
                          child: const FittedBox(
                            child: Row(
                              children: [
                                Text(
                                  "Remover ",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (_selectedIndex == index)
                  InsertProductQuantityForm(
                    insertQuantityFocusNode: _insertQuantityFocusNode,
                    enterpriseCode: widget.enterpriseCode,
                    searchProductController: widget.consultedProductController,
                    consultedProductFormKey: _consultedProductFormKey,
                    totalItemValue: _totalItemValue,
                    product: product,
                    addProductInCart: () async {
                      if (_totalItemValue == 0) {
                        ShowSnackbarMessage.show(
                          message: "O total dos itens está zerado!",
                          context: context,
                        );
                      }
                      saleRequestProvider.addProductInCart(
                        consultedProductController:
                            widget.consultedProductController,
                        product: product,
                        enterpriseCode: widget.enterpriseCode.toString(),
                      );
                      setState(() {
                        _selectedIndex = -1;
                      });

                      if (configurationsProvider.autoScan?.value == true) {
                        await widget.getProductsWithCamera();
                      }
                    },
                    totalItensInCart: _totalItensInCart,
                    updateTotalItemValue: () {
                      setState(() {
                        _totalItemValue = saleRequestProvider.getTotalItemValue(
                          product: product,
                          consultedProductController:
                              widget.consultedProductController,
                          enterpriseCode: widget.enterpriseCode.toString(),
                        );
                      });
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
