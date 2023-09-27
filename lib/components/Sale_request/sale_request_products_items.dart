import 'package:celta_inventario/Components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/Components/Sale_request/sale_request_insert_product_quantity_form.dart';
import 'package:celta_inventario/components/Global_widgets/show_all_stocks.dart';
import 'package:celta_inventario/components/Global_widgets/show_snackbar_message.dart';
import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:celta_inventario/utils/convert_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/sale_request_models/sale_request_products_model.dart';
import '../Global_widgets/show_alert_dialog.dart';

class SaleRequestProductsItems extends StatefulWidget {
  final TextEditingController consultedProductController;
  final int enterpriseCode;
  final Function getProductsWithCamera;

  const SaleRequestProductsItems({
    required this.getProductsWithCamera,
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
                SaleRequestProductsModel product =
                    saleRequestProvider.products[index];

                if (saleRequestProvider.productsCount == 1) {
                  selectedIndex = index;
                }

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

                return Card(
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
                                  ShowSnackbarMessage.showMessage(
                                    message:
                                        "O preço de venda e atacado estão zerados! Utilize esse produto somente caso esteja utilizando modelo de pedido de vendas que utiliza o custo como preço!",
                                    context: context,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    secondsDuration: 7,
                                  );
                                }
                                widget.consultedProductController.clear();
                                //necessário apagar o campo da quantidade quando
                                //mudar de produto selecionado

                                FocusScope.of(context).unfocus();

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
                            otherWidget: ShowAllStocks.showAllStocks(
                              productModel: product,
                              hasAssociatedsStock: product.StorageAreaAddress !=
                                      "" ||
                                  product.StockByEnterpriseAssociateds.length >
                                      0,
                              hasStocks: product.Stocks.length > 0,
                              context: context,
                              stockByEnterpriseAssociatedsLength:
                                  product.StockByEnterpriseAssociateds.length,
                              stocksLength: product.Stocks.length,
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
                            subtitleColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Preço de atacado",
                            value: ConvertString.convertToBRL(
                              product.WholePracticedPrice,
                            ),
                            subtitleColor: Colors.black,
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Qtd mínima p/ atacado",
                            value: ConvertString.convertToBrazilianNumber(
                              product.MinimumWholeQuantity.toString(),
                            ),
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Estoque de venda",
                            value: ConvertString.convertToBrazilianNumber(
                              product.BalanceStockSale.toString(),
                            ),
                            otherWidget: Icon(
                              selectedIndex != index
                                  ? Icons.arrow_drop_down_sharp
                                  : Icons.arrow_drop_up_sharp,
                              color: Theme.of(context).colorScheme.primary,
                              size: 30,
                            ),
                          ),
                          if (saleRequestProvider.alreadyContainsProduct(
                            ProductPackingCode: product.ProductPackingCode,
                            enterpriseCode: widget.enterpriseCode.toString(),
                          ))
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FittedBox(
                                  child: Text(
                                    "Qtd no carrinho: " +
                                        saleRequestProvider
                                            .getTotalItensInCart(
                                              ProductPackingCode:
                                                  product.ProductPackingCode,
                                              enterpriseCode: widget
                                                  .enterpriseCode
                                                  .toString(),
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
                                FittedBox(
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      // primary: _totalItensInCart > 0
                                      //     ? Colors.red
                                      //     : Colors.grey,
                                    ),
                                    onPressed: _totalItensInCart > 0
                                        ? () => removeProduct(
                                              saleRequestProvider:
                                                  saleRequestProvider,
                                              totalItemValue: _totalItemValue,
                                              product: product,
                                            )
                                        : null,
                                    child: const Row(
                                      children: [
                                        Text(
                                          "Remover produto",
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
                              ],
                            ),
                          if (selectedIndex == index)
                            SaleRequestInsertProductQuantityForm(
                              enterpriseCode: widget.enterpriseCode,
                              consultedProductController:
                                  widget.consultedProductController,
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
                                  enterpriseCode:
                                      widget.enterpriseCode.toString(),
                                );
                                setState(() {
                                  selectedIndex = -1;
                                });

                                if (saleRequestProvider.useAutoScan) {
                                  await widget.getProductsWithCamera();
                                }
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
