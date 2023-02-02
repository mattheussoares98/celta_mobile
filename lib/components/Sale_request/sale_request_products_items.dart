import 'package:celta_inventario/Components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/Components/Sale_request/sale_request_associated_stocks_alert_dialog.dart';
import 'package:celta_inventario/Components/Sale_request/sale_request_insert_product_quantity_form.dart';
import 'package:celta_inventario/components/Global_widgets/personalized_card.dart';
import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:celta_inventario/utils/convert_string.dart';
import 'package:celta_inventario/Components/Global_widgets/show_error_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaleRequestProductsItems extends StatefulWidget {
  final TextEditingController consultedProductController;
  final int enterpriseCode;

  const SaleRequestProductsItems({
    required this.consultedProductController,
    required this.enterpriseCode,
    Key? key,
  }) : super(key: key);

  @override
  State<SaleRequestProductsItems> createState() =>
      _SaleRequestProductsItemsState();
}

class _SaleRequestProductsItemsState extends State<SaleRequestProductsItems> {
  int selectedIndex = -1;

  GlobalKey<FormState> _consultedProductFormKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // if (widget.consultedProductController.text == '') {
    //   setState(() {
    //     _totalItemValue = 0;
    //     selectedIndex = -1;
    //   });
    // }
  }

  changeCursorToLastIndex() {
    widget.consultedProductController.selection = TextSelection.collapsed(
      offset: widget.consultedProductController.text.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider = Provider.of(
      context,
      listen: true,
    );

    return Expanded(
      child: Column(
        mainAxisAlignment: saleRequestProvider.productsCount > 1
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: saleRequestProvider.productsCount,
              itemBuilder: (context, index) {
                var product = saleRequestProvider.products[index];

                double _quantityToAdd =
                    saleRequestProvider.tryChangeControllerTextToDouble(
                        widget.consultedProductController);

                double _totalItensInCart =
                    saleRequestProvider.getTotalItensInCart(
                  ProductPackingCode: product.ProductPackingCode,
                  enterpriseCode: widget.enterpriseCode.toString(),
                );

                double _totalItemValue = saleRequestProvider.getTotalItemValue(
                  product: product,
                  consultedProductController: widget.consultedProductController,
                  enterpriseCode: widget.enterpriseCode.toString(),
                );

                if (saleRequestProvider.productsCount == 1 &&
                    selectedIndex != index) {
                  selectedIndex = index;
                  Future.delayed(const Duration(milliseconds: 300), () {
                    FocusScope.of(context).requestFocus(
                      saleRequestProvider.consultedProductFocusNode,
                    );
                  });
                }

                // double _totalItemValue = saleRequestProvider.getTotalItemValue(
                //   product: product,
                //   consultedProductController: widget.consultedProductController,
                // );

                return PersonalizedCard.personalizedCard(
                  context: context,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: saleRequestProvider.isLoadingProducts
                          ? null
                          : () {
                              if (!saleRequestProvider
                                      .consultedProductFocusNode.hasFocus &&
                                  selectedIndex == index) {
                                Future.delayed(
                                    const Duration(milliseconds: 100), () {
                                  FocusScope.of(context).requestFocus(
                                    saleRequestProvider
                                        .consultedProductFocusNode,
                                  );
                                });
                                return;
                              }

                              if (selectedIndex != index) {
                                if (product.RetailPracticedPrice == 0 &&
                                    product.WholePracticedPrice == 0) {
                                  ShowErrorMessage.showErrorMessage(
                                    error:
                                        "O preço de venda e atacado estão zerados, por isso não é possível inserir a quantidade",
                                    context: context,
                                  );
                                  return;
                                }
                                _quantityToAdd = 0;
                                widget.consultedProductController.clear();
                                //necessário apagar o campo da quantidade quando
                                //mudar de produto selecionado

                                Future.delayed(
                                    const Duration(milliseconds: 100), () {
                                  FocusScope.of(context).requestFocus(
                                    saleRequestProvider
                                        .consultedProductFocusNode,
                                  );
                                });
                                setState(() {
                                  selectedIndex = index;
                                });
                              } else {
                                FocusScope.of(context).unfocus();
                                //quando clica no mesmo produto, fecha o teclado
                                setState(() {
                                  selectedIndex = -1;
                                });
                              }
                            },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "PLU",
                            value: product.PLU.toString(),
                            otherWidget: SaleRequestAssociatedStocksWidget
                                .saleRequestAssociatedStocksWidget(
                              context: context,
                              product: product,
                            ),
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Produto",
                            value: product.Name.toString() +
                                " (${product.PackingQuantity})",
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Preço de venda",
                            value: ConvertString.convertToBRL(
                              product.RetailPracticedPrice,
                            ),
                            subtitleColor: selectedIndex == index
                                ? _quantityToAdd + _totalItensInCart <
                                            saleRequestProvider
                                                .products[selectedIndex]
                                                .MinimumWholeQuantity ||
                                        saleRequestProvider
                                                .products[selectedIndex]
                                                .MinimumWholeQuantity ==
                                            0
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.black
                                : Colors.black,
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Preço de atacado",
                            value: ConvertString.convertToBRL(
                              product.WholePracticedPrice,
                            ),
                            subtitleColor: selectedIndex == index &&
                                    saleRequestProvider.products[selectedIndex]
                                            .MinimumWholeQuantity >
                                        0
                                ? _quantityToAdd + _totalItensInCart <
                                        saleRequestProvider
                                            .products[selectedIndex]
                                            .MinimumWholeQuantity
                                    ? Colors.black
                                    : Theme.of(context).colorScheme.primary
                                : Colors.black,
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Quantidade mínima para atacado",
                            value: product.MinimumWholeQuantity.toString(),
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Saldo estoque de venda",
                            value: product.BalanceStockSale.toString(),
                            otherWidget: Icon(
                              selectedIndex != index
                                  ? Icons.arrow_drop_down_sharp
                                  : Icons.arrow_drop_up_sharp,
                              color: Theme.of(context).colorScheme.primary,
                              size: 40,
                            ),
                          ),
                          if (saleRequestProvider.alreadyContainsProduct(
                            ProductPackingCode: product.ProductPackingCode,
                            enterpriseCode: widget.enterpriseCode.toString(),
                          ))
                            TitleAndSubtitle.titleAndSubtitle(
                              // titleColor: Theme.of(context).colorScheme.primary,
                              subtitleColor: Colors.red,
                              value: "Quantidade no carrinho: " +
                                  saleRequestProvider
                                      .getTotalItensInCart(
                                        ProductPackingCode:
                                            product.ProductPackingCode,
                                        enterpriseCode:
                                            widget.enterpriseCode.toString(),
                                      )
                                      .toStringAsFixed(3)
                                      .replaceAll(RegExp(r'\.'), ','),
                            ),
                          if (selectedIndex == index)
                            SaleRequestInsertProductQuantityForm(
                              enterpriseCode: widget.enterpriseCode,
                              consultedProductController:
                                  widget.consultedProductController,
                              consultedProductFormKey: _consultedProductFormKey,
                              totalItemValue: _totalItemValue,
                              product: product,
                              addProductInCart: () {
                                if (_totalItemValue == 0) {
                                  ShowErrorMessage.showErrorMessage(
                                    error: "O total dos itens está zerado!",
                                    context: context,
                                  );
                                }
                                saleRequestProvider.addProductInCart(
                                  consultedProductController:
                                      widget.consultedProductController,
                                  product: product,
                                  enterpriseCode:
                                      widget.enterpriseCode.toString(),
                                );
                              },
                              totalItensInCart: _totalItensInCart,
                              updateTotalItemValue: () {
                                setState(() {
                                  _totalItemValue =
                                      saleRequestProvider.getTotalItemValue(
                                    product: product,
                                    consultedProductController:
                                        widget.consultedProductController,
                                    enterpriseCode:
                                        widget.enterpriseCode.toString(),
                                  );
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
