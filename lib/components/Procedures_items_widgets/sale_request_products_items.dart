import 'package:celta_inventario/components/personalized_card.dart';
import 'package:celta_inventario/providers/sale_request_provider.dart';
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
    required String title,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.max,
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
      ],
    );
  }

  GlobalKey<FormState> _consultedProductFormKey = GlobalKey();

  double _totalItemValue = 0;
  double quantityToAdd = null ?? 0;

  updateTotalItemValue({
    required double salePraticedPrice,
    required double wholeMinimumQuantity,
    required double wholePrice,
  }) {
    if (double.tryParse(widget.consultedProductController.text) != null) {
      quantityToAdd = double.tryParse(widget.consultedProductController.text)!;
    }

    if (wholeMinimumQuantity == 0) {
      setState(() {
        _totalItemValue = quantityToAdd * salePraticedPrice;
      });
    } else if (quantityToAdd < wholeMinimumQuantity) {
      setState(() {
        _totalItemValue = quantityToAdd * salePraticedPrice;
      });
    } else {
      setState(() {
        _totalItemValue = quantityToAdd * wholePrice;
      });
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
                                quantityToAdd = 0;
                                widget.consultedProductController.clear();
                                widget.consultedProductController.selection =
                                    TextSelection.collapsed(
                                  offset: widget
                                      .consultedProductController.text.length,
                                );
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
                                  product.RetailPracticedPrice.toString()
                                          .replaceFirst(RegExp(r'\.'), ',') +
                                      "R\$",
                                  style: selectedIndex == index
                                      ? TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: quantityToAdd <
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
                                  double.parse(product.WholePracticedPrice
                                              .toString())
                                          .toStringAsFixed(2)
                                          .toString()
                                          .replaceFirst(RegExp(r'\.'), ',') +
                                      "R\$",
                                  style: selectedIndex == index &&
                                          saleRequestProvider
                                                  .products[selectedIndex]
                                                  .MinimumWholeQuantity >
                                              0
                                      ? TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: quantityToAdd <
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
                                              quantityToAdd = 0;
                                            } else {
                                              quantityToAdd = double.tryParse(
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
                                                    quantityToAdd = 0;
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
                                          quantityToAdd++;
                                          widget.consultedProductController
                                                  .text =
                                              quantityToAdd.toStringAsFixed(3);
                                        });

                                        updateTotalItemValue(
                                          salePraticedPrice:
                                              product.RetailPracticedPrice,
                                          wholeMinimumQuantity:
                                              product.MinimumWholeQuantity,
                                          wholePrice:
                                              product.WholePracticedPrice,
                                        );
                                        widget.consultedProductController
                                                .selection =
                                            TextSelection.collapsed(
                                          offset: widget
                                              .consultedProductController
                                              .text
                                              .length,
                                        );
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
                                          onPressed: _totalItemValue == 0
                                              ? () {} //se deixar como nulo, ao clicar no botão está minimizando os campos de inserção
                                              : () {
                                                  saleRequestProvider
                                                      .addProductInCart(
                                                    ProductPackingCode: product
                                                        .ProductPackingCode,
                                                    Quantity: quantityToAdd,
                                                    Value: _totalItemValue,
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
                                                      "${_totalItemValue.toStringAsFixed(2).toString().replaceAll(RegExp(r'\.'), ',')} R\$"),
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
                                          if (quantityToAdd <= 1) {
                                            quantityToAdd = 0;
                                            widget.consultedProductController
                                                .clear();
                                          } else {
                                            quantityToAdd--;
                                            widget.consultedProductController
                                                    .text =
                                                quantityToAdd
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
                                        widget.consultedProductController
                                                .selection =
                                            TextSelection.collapsed(
                                          offset: widget
                                              .consultedProductController
                                              .text
                                              .length,
                                        );
                                      },
                                      icon: Icon(
                                        Icons.remove,
                                        color: quantityToAdd == 0
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
