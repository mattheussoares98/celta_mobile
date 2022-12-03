import 'package:celta_inventario/components/personalized_card.dart';
import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:celta_inventario/utils/convert_string.dart';
import 'package:celta_inventario/utils/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _SaleRequestProductsItemsState extends State<SaleRequestProductsItems>
    with ConvertString {
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

  double _totalItemValue = 0;
  double _quantityToAdd = null ?? 0;
  double _totalItemQuantity = 0;
  double _praticedPrice = 0;

  updateTotalItemValue({
    required double salePracticedPrice,
    required double wholeMinimumQuantity,
    required double wholePrice,
  }) {
    if (double.tryParse(widget.consultedProductController.text) != null) {
      _quantityToAdd = double.tryParse(widget.consultedProductController.text)!;
    }

    _praticedPrice = getPraticedPrice(
      salePracticedPrice: salePracticedPrice,
      wholeMinimumQuantity: wholeMinimumQuantity,
      wholePrice: wholePrice,
    );

    setState(() {
      _totalItemValue = _quantityToAdd * _praticedPrice;
    });
  }

  double getPraticedPrice({
    required double salePracticedPrice,
    required double wholeMinimumQuantity,
    required double wholePrice,
  }) {
    if (wholeMinimumQuantity == 0) {
      return salePracticedPrice;
    } else if ((_quantityToAdd + _totalItemQuantity) < wholeMinimumQuantity) {
      return salePracticedPrice;
    } else {
      return wholePrice;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.consultedProductController.text == '') {
      setState(() {
        _totalItemValue = 0;
        selectedIndex = -1;
      });
    }
  }

  changeCursorToLastIndex() {
    widget.consultedProductController.selection = TextSelection.collapsed(
      offset: widget.consultedProductController.text.length,
    );
  }

  addProductInCart({
    required SaleRequestProvider saleRequestProvider,
    required int ProductPackingCode,
    required double RetailPracticedPrice,
    required double MinimumWholeQuantity,
    required double WholePracticedPrice,
  }) {
    double praticedPrice = getPraticedPrice(
      salePracticedPrice: RetailPracticedPrice,
      wholeMinimumQuantity: MinimumWholeQuantity,
      wholePrice: WholePracticedPrice,
    );

    saleRequestProvider.addProductInCart(
      ProductPackingCode: ProductPackingCode,
      Quantity: _quantityToAdd,
      Value: praticedPrice,
      context: context,
      alreadyContaintProduct: saleRequestProvider.alreadyContainsProduct(
        ProductPackingCode,
      ), //se já houver o produto no carrinho, vai somar a quantidade
    );

    widget.consultedProductController.text = "0";
    _quantityToAdd = 0;

    updateTotalItemValue(
      salePracticedPrice: RetailPracticedPrice,
      wholeMinimumQuantity: MinimumWholeQuantity,
      wholePrice: WholePracticedPrice,
    );

    changeCursorToLastIndex();

    _totalItemQuantity = saleRequestProvider.getAtualQuantity(
      ProductPackingCode: ProductPackingCode,
    );

    setState(() {});
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
                return PersonalizedCard.personalizedCard(
                  context: context,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: saleRequestProvider.isLoadingProducts
                          ? null
                          : () {
                              if (saleRequestProvider.alreadyContainsProduct(
                                product.ProductPackingCode,
                              )) {
                                _totalItemQuantity =
                                    saleRequestProvider.getAtualQuantity(
                                  ProductPackingCode:
                                      product.ProductPackingCode,
                                );
                              } else {
                                _totalItemQuantity = 0;
                              }

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

                              updateTotalItemValue(
                                salePracticedPrice:
                                    product.RetailPracticedPrice,
                                wholeMinimumQuantity:
                                    product.MinimumWholeQuantity,
                                wholePrice: product.WholePracticedPrice,
                              );
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
                                                0.8,
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
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Endereço",
                                                          style:
                                                              Theme.of(context)
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
                                                    Text(
                                                      product.StockByEnterpriseAssociateds[
                                                          index]["Enterprise"],
                                                    ),
                                                    Text(
                                                      product
                                                          .StockByEnterpriseAssociateds[
                                                              index][
                                                              "StockBalanceForSale"]
                                                          .toString(),
                                                    ),
                                                    Text(
                                                      product.StockByEnterpriseAssociateds[
                                                                  index][
                                                              "StorageAreaAddress"] =
                                                          null ?? "Não há",
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
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                "Preço de venda: ",
                                style: _fontStyle(),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  ConvertString.convertToBRL(
                                    product.RetailPracticedPrice,
                                  ),
                                  style: selectedIndex == index
                                      ? TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: _quantityToAdd +
                                                          _totalItemQuantity <
                                                      saleRequestProvider
                                                          .products[
                                                              selectedIndex]
                                                          .MinimumWholeQuantity ||
                                                  saleRequestProvider
                                                          .products[
                                                              selectedIndex]
                                                          .MinimumWholeQuantity ==
                                                      0
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Colors.black,
                                          fontFamily: 'OpenSans',
                                          fontSize: 17,
                                        )
                                      : _fontBoldStyle(),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                "Preço de atacado: ",
                                style: _fontStyle(),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  ConvertString.convertToBRL(
                                    product.WholePracticedPrice,
                                  ),
                                  style: selectedIndex == index &&
                                          saleRequestProvider
                                                  .products[selectedIndex]
                                                  .MinimumWholeQuantity >
                                              0
                                      ? TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: _quantityToAdd +
                                                      _totalItemQuantity <
                                                  saleRequestProvider
                                                      .products[selectedIndex]
                                                      .MinimumWholeQuantity
                                              ? Colors.black
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                          fontFamily: 'OpenSans',
                                          fontSize: 17,
                                        )
                                      : _fontBoldStyle(),
                                  maxLines: 2,
                                ),
                              ),
                            ],
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
                              titleColor: Theme.of(context).colorScheme.primary,
                              subtitleColor:
                                  Theme.of(context).colorScheme.primary,
                              value: "Quantidade no carrinho: " +
                                  _totalItemQuantity
                                      .toString()
                                      .replaceAll(RegExp(r'\.'), ','),
                            ),
                          if (selectedIndex == index)
                            Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Divider(
                                    color: Colors.grey,
                                    height: 3,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Form(
                                      key: _consultedProductFormKey,
                                      child: Expanded(
                                        child: TextFormField(
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(10)
                                          ],
                                          focusNode: saleRequestProvider
                                              .consultedProductFocusNode,
                                          controller:
                                              widget.consultedProductController,
                                          keyboardType: TextInputType.number,
                                          onChanged: (text) {
                                            if (widget
                                                .consultedProductController
                                                .text
                                                .isEmpty) {
                                              _quantityToAdd = 0;
                                            } else {
                                              _quantityToAdd = double.tryParse(
                                                widget
                                                    .consultedProductController
                                                    .text
                                                    .replaceAll(
                                                        RegExp(r','), '\.'),
                                              )!;
                                            }

                                            updateTotalItemValue(
                                              salePracticedPrice:
                                                  product.RetailPracticedPrice,
                                              wholeMinimumQuantity:
                                                  product.MinimumWholeQuantity,
                                              wholePrice:
                                                  product.WholePracticedPrice,
                                            );
                                          },
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                style: BorderStyle.solid,
                                                width: 2,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                            ),
                                            suffixIcon: Padding(
                                              padding: const EdgeInsets.only(
                                                right: 20,
                                              ),
                                              child: IconButton(
                                                onPressed: () {
                                                  widget
                                                      .consultedProductController
                                                      .clear();
                                                  setState(() {
                                                    _quantityToAdd = 0;
                                                    _totalItemValue = 0;
                                                  });
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    IconButton(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      onPressed: () {
                                        setState(() {
                                          _quantityToAdd++;
                                          widget.consultedProductController
                                                  .text =
                                              _quantityToAdd
                                                  .toStringAsFixed(3)
                                                  .replaceAll(
                                                      RegExp(r'\.'), ',');
                                        });

                                        updateTotalItemValue(
                                          salePracticedPrice:
                                              product.RetailPracticedPrice,
                                          wholeMinimumQuantity:
                                              product.MinimumWholeQuantity,
                                          wholePrice:
                                              product.WholePracticedPrice,
                                        );
                                        changeCursorToLastIndex();
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  // mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 60,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary:
                                                widget.consultedProductController
                                                            .text.isEmpty &&
                                                        _totalItemQuantity > 0
                                                    ? Colors.red
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                          ),
                                          onPressed:
                                              widget.consultedProductController
                                                          .text.isEmpty &&
                                                      _totalItemQuantity > 0
                                                  ? () {
                                                      ShowAlertDialog()
                                                          .showAlertDialog(
                                                        context: context,
                                                        title:
                                                            "Confirmar exclusão",
                                                        subtitle:
                                                            "Deseja excluir o produto do carrinho?",
                                                        function: () {
                                                          saleRequestProvider
                                                              .removeProductFromCart(
                                                            product
                                                                .ProductPackingCode,
                                                          );

                                                          updateTotalItemValue(
                                                            salePracticedPrice:
                                                                product
                                                                    .RetailPracticedPrice,
                                                            wholeMinimumQuantity:
                                                                product
                                                                    .MinimumWholeQuantity,
                                                            wholePrice: product
                                                                .WholePracticedPrice,
                                                          );

                                                          _totalItemQuantity =
                                                              saleRequestProvider
                                                                  .getAtualQuantity(
                                                            ProductPackingCode:
                                                                product
                                                                    .ProductPackingCode,
                                                          );
                                                          setState(() {});
                                                        },
                                                      );
                                                    }
                                                  : () {
                                                      if (_totalItemValue == 0)
                                                        return;

                                                      addProductInCart(
                                                        saleRequestProvider:
                                                            saleRequestProvider,
                                                        ProductPackingCode: product
                                                            .ProductPackingCode,
                                                        RetailPracticedPrice:
                                                            product
                                                                .RetailPracticedPrice,
                                                        MinimumWholeQuantity:
                                                            product
                                                                .MinimumWholeQuantity,
                                                        WholePracticedPrice: product
                                                            .WholePracticedPrice,
                                                      );
                                                    },
                                          child: widget
                                                      .consultedProductController
                                                      .text
                                                      .isEmpty &&
                                                  _totalItemQuantity > 0
                                              ? const Text(
                                                  "Remover produto do carrinho")
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          const Text("Total"),
                                                          Text(
                                                            ConvertString
                                                                .convertToBRL(
                                                              _totalItemValue,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          const Text(
                                                            "Adicionar",
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                          ),
                                                          const Icon(
                                                            Icons.shopping_cart,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    IconButton(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      onPressed: () {
                                        setState(() {
                                          if (_quantityToAdd <= 1) {
                                            _quantityToAdd = 0;
                                            widget.consultedProductController
                                                .clear();
                                          } else {
                                            _quantityToAdd--;
                                            widget.consultedProductController
                                                    .text =
                                                _quantityToAdd
                                                    .toStringAsFixed(3)
                                                    .replaceAll(
                                                        RegExp(r'\.'), ',');
                                          }

                                          updateTotalItemValue(
                                            salePracticedPrice:
                                                product.RetailPracticedPrice,
                                            wholeMinimumQuantity:
                                                product.MinimumWholeQuantity,
                                            wholePrice:
                                                product.WholePracticedPrice,
                                          );
                                        });
                                        changeCursorToLastIndex();
                                      },
                                      icon: Icon(
                                        Icons.remove,
                                        color: widget.consultedProductController
                                                .text.isEmpty
                                            ? Colors.grey
                                            : Theme.of(context)
                                                .colorScheme
                                                .primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
