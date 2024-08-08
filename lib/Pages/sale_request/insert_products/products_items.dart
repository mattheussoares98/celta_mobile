import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/soap/soap.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';
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
    required dynamic product,
  }) {
    ShowAlertDialog.showAlertDialog(
      context: context,
      title: "Confirmar exclusão",
      subtitle: "Deseja excluir o produto do carrinho?",
      function: () {
        setState(() {
          saleRequestProvider.removeProductFromCart(
            ProductPackingCode: product.ProductPackingCode,
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

  changeFocusToConsultedProductFocusNode({
    required SaleRequestProvider saleRequestProvider,
  }) {
    Future.delayed(const Duration(milliseconds: 300), () {
      //se não colocar em um future pra mudar o foco,
      //não funciona corretamente
      FocusScope.of(context).requestFocus(
        saleRequestProvider.consultedProductFocusNode,
      );
    });
  }

  selectIndexAndFocus({
    required SaleRequestProvider saleRequestProvider,
    required int index,
    required GetProductJsonModel product,
  }) {
    widget.consultedProductController.text = "";

    if (product.retailPracticedPrice == 0 && product.wholePracticedPrice == 0) {
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
    required SaleRequestProvider saleRequestProvider,
    required int index,
    required ConfigurationsProvider configurationsProvider,
  }) {
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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          focusColor: Colors.white.withOpacity(0),
          hoverColor: Colors.white.withOpacity(0),
          splashColor: Colors.white.withOpacity(0),
          highlightColor: Colors.white.withOpacity(0),
          onTap: saleRequestProvider.isLoadingProducts
              ? null
              : () {
                  selectIndexAndFocus(
                    saleRequestProvider: saleRequestProvider,
                    index: index,
                    product: product,
                  );
                },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TitleAndSubtitle.titleAndSubtitle(
                title: "PLU",
                subtitle: product.plu.toString(),
                otherWidget: OpenDialogProductInformations(
                  product: product,
                ),
              ),
              TitleAndSubtitle.titleAndSubtitle(
                title: "Produto",
                subtitle:
                    product.name.toString() + " (${product.packingQuantity})",
              ),
              TitleAndSubtitle.titleAndSubtitle(
                title: "Preço de venda",
                subtitle: ConvertString.convertToBRL(
                  product.value,
                ),
                subtitleColor: Theme.of(context).colorScheme.primary,
              ),
              TitleAndSubtitle.titleAndSubtitle(
                title: "Preço de atacado",
                subtitle: ConvertString.convertToBRL(
                  product.wholePracticedPrice,
                ),
                subtitleColor: Colors.black,
              ),
              TitleAndSubtitle.titleAndSubtitle(
                title: "Qtd mínima p/ atacado",
                subtitle: ConvertString.convertToBrazilianNumber(
                  product.minimumWholeQuantity.toString(),
                ),
              ),
              TitleAndSubtitle.titleAndSubtitle(
                title: "Estoque de venda",
                subtitle: ConvertString.convertToBrazilianNumber(
                  product.balanceStockSale.toString(),
                ),
                otherWidget: Icon(
                  _selectedIndex != index
                      ? Icons.arrow_drop_down_sharp
                      : Icons.arrow_drop_up_sharp,
                  color: Theme.of(context).colorScheme.primary,
                  size: 30,
                ),
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
                          color:
                              _totalItensInCart > 0 ? Colors.red : Colors.grey,
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
                          // primary: _totalItensInCart > 0
                          //     ? Colors.red
                          //     : Colors.grey,
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
                  enterpriseCode: widget.enterpriseCode,
                  consultedProductController: widget.consultedProductController,
                  consultedProductFormKey: _consultedProductFormKey,
                  totalItemValue: _totalItemValue,
                  product: product,
                  addProductInCart: () async {
                    if (_totalItemValue == 0) {
                      ShowSnackbarMessage.showMessage(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider = Provider.of(
      context,
      listen: true,
    );
    ConfigurationsProvider configurationsProvider = Provider.of(
      context,
      listen: true,
    );

    int itensPerLine = ResponsiveItems.getItensPerLine(context);
    int productsCount = saleRequestProvider.productsCount;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: productsCount,
      itemBuilder: (context, index) {
        if (saleRequestProvider.productsCount == 1) {
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
                  saleRequestProvider: saleRequestProvider,
                  configurationsProvider: configurationsProvider,
                ),
              ),
          ],
        );
      },
    );
  }
}
