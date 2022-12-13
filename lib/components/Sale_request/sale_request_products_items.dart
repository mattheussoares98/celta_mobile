import 'package:celta_inventario/Components/Sale_request/sale_request_insert_quantity_form.dart';
import 'package:celta_inventario/components/Global_widgets/personalized_card.dart';
import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:celta_inventario/utils/convert_string.dart';
import 'package:celta_inventario/utils/show_error_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaleRequestProductsItems extends StatefulWidget {
  final TextEditingController consultedProductController;

  const SaleRequestProductsItems({
    required this.consultedProductController,
    Key? key,
  }) : super(key: key);

  @override
  State<SaleRequestProductsItems> createState() =>
      _SaleRequestProductsItemsState();
}

class _SaleRequestProductsItemsState extends State<SaleRequestProductsItems> {
  int selectedIndex = -1;

  TextStyle _fontStyle({Color? color = Colors.black}) => TextStyle(
        fontSize: 17,
        color: color,
        fontFamily: 'OpenSans',
      );
  TextStyle _fontBoldStyle({Color? color = Colors.black}) => TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: color,
      );

  Widget values({
    Color? titleColor,
    Color? subtitleColor,
    Widget? otherWidget,
    String? title,
    required String value,
  }) {
    return Row(
      children: [
        Text(
          title == null ? "" : "${title}: ",
          style: _fontStyle(color: titleColor),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            style: _fontBoldStyle(color: subtitleColor),
            maxLines: 2,
          ),
        ),
        if (otherWidget != null) otherWidget,
      ],
    );
  }

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

                double _quantityToAdd = saleRequestProvider
                    .getQuantityToAdd(widget.consultedProductController);

                double _totalItensInCart = saleRequestProvider
                    .getTotalItensInCart(product.ProductPackingCode);

                double _totalItemValue = saleRequestProvider.getTotalItemValue(
                  product: product,
                  consultedProductController: widget.consultedProductController,
                );

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
                                widget.consultedProductController.text = "0";
                                changeCursorToLastIndex();
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
                          values(
                            title: "PLU",
                            value: product.PLU.toString(),
                            otherWidget: InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                          scrollable: true,
                                          content: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.5,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: product
                                                  .StockByEnterpriseAssociateds
                                                  .length,
                                              itemBuilder: (
                                                BuildContext context,
                                                int index,
                                              ) {
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    if (index == 0)
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          FittedBox(
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "Endereço na empresa atual: ",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline2,
                                                                ),
                                                                Text(
                                                                  product.StorageAreaAddress ==
                                                                          ""
                                                                      ? "não há"
                                                                      : product
                                                                          .StorageAreaAddress,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          const Divider(
                                                            height: 3,
                                                            color: Colors.grey,
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                        ],
                                                      ),
                                                    if (index == 0 &&
                                                        product.StockByEnterpriseAssociateds
                                                                .length >
                                                            1)
                                                      Column(
                                                        children: [
                                                          const SizedBox(
                                                            height: 40,
                                                          ),
                                                          const FittedBox(
                                                            child: Text(
                                                              "Estoque nas empresas associadas",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                letterSpacing:
                                                                    0.3,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 30,
                                                                fontFamily:
                                                                    "BebasNeue",
                                                              ),
                                                            ),
                                                          ),
                                                          const Divider(
                                                            height: 3,
                                                            color: Colors.grey,
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      ),
                                                    FittedBox(
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "Empresa: ",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline2,
                                                          ),
                                                          Text(
                                                            product.StockByEnterpriseAssociateds[
                                                                    index]
                                                                ["Enterprise"],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    FittedBox(
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "Estoque de venda: ",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline2,
                                                          ),
                                                          Text(
                                                            product
                                                                .StockByEnterpriseAssociateds[
                                                                    index][
                                                                    "StockBalanceForSale"]
                                                                .toStringAsFixed(
                                                                    3)
                                                                .replaceAll(
                                                                    RegExp(
                                                                        r'\.'),
                                                                    ','),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    FittedBox(
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "Endereços: ",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline2,
                                                          ),
                                                          Text(
                                                            product.StockByEnterpriseAssociateds[
                                                                            index]
                                                                        [
                                                                        "StorageAreaAddress"] ==
                                                                    null
                                                                ? "Não há"
                                                                : product
                                                                    .StockByEnterpriseAssociateds[
                                                                        index][
                                                                        "StorageAreaAddress"]
                                                                    .toString()
                                                                    .replaceAll(
                                                                        RegExp(
                                                                            r'\['),
                                                                        '- ')
                                                                    .replaceAll(
                                                                        RegExp(
                                                                            r'\]'),
                                                                        '')
                                                                    .replaceAll(
                                                                        RegExp(
                                                                            r'\, '),
                                                                        '\n- '),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Divider(
                                                      height: 2,
                                                      color: Colors.black,
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ));
                                    });
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "Estoque",
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  Icon(
                                    Icons.info,
                                    size: 30,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          values(
                            title: "Produto",
                            value: product.Name.toString() +
                                " (${product.PackingQuantity})",
                          ),
                          values(
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
                          values(
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
                          values(
                            title: "Quantidade mínima para atacado",
                            value: product.MinimumWholeQuantity.toString(),
                          ),
                          values(
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
                            product.ProductPackingCode,
                          ))
                            values(
                              // titleColor: Theme.of(context).colorScheme.primary,
                              subtitleColor: Colors.green[700],
                              value: "Quantidade no carrinho: " +
                                  saleRequestProvider
                                      .getTotalItensInCart(
                                        product.ProductPackingCode,
                                      )
                                      .toStringAsFixed(3)
                                      .replaceAll(RegExp(r'\.'), ','),
                            ),
                          if (selectedIndex == index)
                            SaleRequestInsertQuantityForm(
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
