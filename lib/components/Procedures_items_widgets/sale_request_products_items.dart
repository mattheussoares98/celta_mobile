import 'package:celta_inventario/components/personalized_card.dart';
import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:celta_inventario/utils/convert_string.dart';
import 'package:celta_inventario/utils/show_alert_dialog.dart';
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

class _SaleRequestProductsItemsState extends State<SaleRequestProductsItems>
    with ConvertString {
  int selectedIndex = -1;

  TextStyle _fontStyle = const TextStyle(
    fontSize: 17,
    color: Colors.black,
    fontFamily: 'OpenSans',
  );
  TextStyle _fontBoldStyle = const TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  Widget values({
    Widget? otherWidget,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Text(
          "${title}: ",
          style: _fontStyle,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            style: _fontBoldStyle,
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

  updateTotalItemValue({
    required double salePraticedPrice,
    required double wholeMinimumQuantity,
    required double wholePrice,
  }) {
    if (double.tryParse(widget.consultedProductController.text) != null) {
      _quantityToAdd = double.tryParse(widget.consultedProductController.text)!;
    }

    double praticedPrice = getPraticedPrice(
      salePraticedPrice: salePraticedPrice,
      wholeMinimumQuantity: wholeMinimumQuantity,
      wholePrice: wholePrice,
    );

    setState(() {
      _totalItemValue = _quantityToAdd * praticedPrice;
    });
  }

  double getPraticedPrice({
    required double salePraticedPrice,
    required double wholeMinimumQuantity,
    required double wholePrice,
  }) {
    if (wholeMinimumQuantity == 0) {
      return salePraticedPrice;
    } else if (_quantityToAdd < wholeMinimumQuantity) {
      return salePraticedPrice;
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
    bool alreadyContainsProduct = saleRequestProvider.alreadyContainsProduct(
      ProductPackingCode,
    );

    double praticedPrice = getPraticedPrice(
      salePraticedPrice: RetailPracticedPrice,
      wholeMinimumQuantity: MinimumWholeQuantity,
      wholePrice: WholePracticedPrice,
    );
    if (alreadyContainsProduct) {
      ShowAlertDialog().showAlertDialog(
        context: context,
        subtitle: "Deseja atualizar a quantidade do produto?",
        title: "O produto já está no carrinho!",
        function: () {
          saleRequestProvider.addProductInCart(
            ProductPackingCode: ProductPackingCode,
            Quantity: _quantityToAdd,
            Value: praticedPrice,
            context: context,
            alreadyContaintProduct: alreadyContainsProduct,
          );
          widget.consultedProductController.text = "";
          _quantityToAdd = 0;

          updateTotalItemValue(
            salePraticedPrice: RetailPracticedPrice,
            wholeMinimumQuantity: MinimumWholeQuantity,
            wholePrice: WholePracticedPrice,
          );

          changeCursorToLastIndex();
        },
      );
    } else {
      saleRequestProvider.addProductInCart(
        ProductPackingCode: ProductPackingCode,
        Quantity: _quantityToAdd,
        Value: praticedPrice,
        context: context,
        alreadyContaintProduct: alreadyContainsProduct,
      );

      widget.consultedProductController.text = "";
      _quantityToAdd = 0;

      updateTotalItemValue(
        salePraticedPrice: RetailPracticedPrice,
        wholeMinimumQuantity: MinimumWholeQuantity,
        wholePrice: WholePracticedPrice,
      );

      changeCursorToLastIndex();
    }
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
                                widget.consultedProductController.clear();
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
                                salePraticedPrice: product.RetailPracticedPrice,
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
                                style: _fontStyle,
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
                                          color: _quantityToAdd <
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
                                      : _fontBoldStyle,
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
                                style: _fontStyle,
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
                                          color: _quantityToAdd <
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
                                      : _fontBoldStyle,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                          values(
                            title: "Quantidade mínima para atacado",
                            value: product.MinimumWholeQuantity.toString(),
                          ),
                          Container(
                            height: 22,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Saldo estoque de venda: ",
                                      style: _fontStyle,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      product.BalanceStockSale.toString(),
                                      style: _fontBoldStyle,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                Icon(
                                  selectedIndex != index
                                      ? Icons.arrow_drop_down_sharp
                                      : Icons.arrow_drop_up_sharp,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 40,
                                ),
                              ],
                            ),
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
                                                    .text,
                                              )!;
                                            }

                                            updateTotalItemValue(
                                              salePraticedPrice:
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
                                              _quantityToAdd.toStringAsFixed(3);
                                        });

                                        updateTotalItemValue(
                                          salePraticedPrice:
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
                                            primary: _totalItemValue == 0
                                                ? Colors.grey[400]
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                          ),
                                          onPressed: () {
                                            if (_totalItemValue == 0) return;

                                            addProductInCart(
                                              saleRequestProvider:
                                                  saleRequestProvider,
                                              ProductPackingCode:
                                                  product.ProductPackingCode,
                                              RetailPracticedPrice:
                                                  product.RetailPracticedPrice,
                                              MinimumWholeQuantity:
                                                  product.MinimumWholeQuantity,
                                              WholePracticedPrice:
                                                  product.WholePracticedPrice,
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  const Text("Total"),
                                                  Text(
                                                    ConvertString.convertToBRL(
                                                      _totalItemValue,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Text(
                                                    "Adicionar",
                                                    style:
                                                        TextStyle(fontSize: 17),
                                                  ),
                                                  const Icon(
                                                    Icons.shopping_cart,
                                                  ),
                                                ],
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
                                                    .toStringAsFixed(3);
                                          }

                                          updateTotalItemValue(
                                            salePraticedPrice:
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
                                        color: _quantityToAdd == 0
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
