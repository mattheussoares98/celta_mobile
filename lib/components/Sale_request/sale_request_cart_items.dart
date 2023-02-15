import 'package:celta_inventario/Components/Global_widgets/insert_quantity_textformfield.dart';
import 'package:celta_inventario/Components/Sale_request/sale_request_cart_products_items.dart';
import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:celta_inventario/utils/convert_string.dart';
import 'package:celta_inventario/Components/Global_widgets/show_alert_dialog.dart';
import 'package:celta_inventario/Components/Global_widgets/show_error_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaleRequestCartItems extends StatefulWidget {
  final TextEditingController textEditingController;
  final int enterpriseCode;
  const SaleRequestCartItems({
    required this.textEditingController,
    required this.enterpriseCode,
    Key? key,
  }) : super(key: key);

  @override
  State<SaleRequestCartItems> createState() => _SaleRequestCartItemsState();
}

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _SaleRequestCartItemsState extends State<SaleRequestCartItems> {
  Widget titleAndSubtitle({
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 100, 97, 97),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  // TextEditingController _textEditingController = TextEditingController();

  int _selectedIndex = -1;

  FocusNode _focusNode = FocusNode();

  changeFocus({
    required SaleRequestProvider saleRequestProvider,
    required int index,
  }) async {
    if (!_focusNode.hasFocus && _selectedIndex == index) {
      Future.delayed(const Duration(milliseconds: 100), () {
        FocusScope.of(context).requestFocus(
          _focusNode,
        );
      });
      return;
    }
    if (_selectedIndex != index) {
      widget.textEditingController.text = "";
      widget.textEditingController.clear();

      setState(() {
        _selectedIndex = index;
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        FocusScope.of(context).requestFocus(
          _focusNode,
        );
      });
    } else {
      FocusScope.of(context).unfocus();
      //quando clica no mesmo produto, fecha o teclado
      setState(() {
        _selectedIndex = -1;
      });
    }
  }

  TextStyle hasMinimumWholeQuantity({
    bool isSaleRetailPrice = false,
    required double minimumWholeQuantity,
  }) {
    var green = TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontSize: 17,
      fontWeight: FontWeight.bold,
    );
    var black = const TextStyle(
      color: Colors.black,
      fontSize: 17,
      fontWeight: FontWeight.bold,
    );
    double? controllerInDouble = double.tryParse(
        widget.textEditingController.text.replaceAll(RegExp(r'\,'), '.'));

    if (isSaleRetailPrice) {
      if (controllerInDouble == null || minimumWholeQuantity <= 0) {
        return green;
      } else if (controllerInDouble < minimumWholeQuantity) {
        return green;
      } else {
        return black;
      }
    } else {
      if (controllerInDouble == null || minimumWholeQuantity <= 0) {
        return black;
      } else if (controllerInDouble >= minimumWholeQuantity) {
        return green;
      } else {
        return black;
      }
    }
  }

  String getNewPrice({
    required double minimumWholeQuantity,
    required double retailPracticedPrice,
    required double wholePracticedPrice,
  }) {
    double? controllerInDouble = double.tryParse(
        widget.textEditingController.text.replaceAll(RegExp(r'\,'), '.'));

    if (controllerInDouble == null) {
      return ConvertString.convertToBRL(0);
    }

    return ConvertString.convertToBRL(
      getPraticedPrice(
            minimumWholeQuantity: minimumWholeQuantity,
            retailPracticedPrice: retailPracticedPrice,
            wholePracticedPrice: wholePracticedPrice,
          ) *
          controllerInDouble,
    );
  }

  double getPraticedPrice({
    required double minimumWholeQuantity,
    required double retailPracticedPrice,
    required double wholePracticedPrice,
  }) {
    double? controllerInDouble = double.tryParse(
      widget.textEditingController.text.replaceAll(RegExp(r'\,'), '.'),
    );

    if (controllerInDouble == null) {
      return 0;
    } else if (controllerInDouble >= minimumWholeQuantity &&
        minimumWholeQuantity > 0) {
      return wholePracticedPrice;
    } else {
      return retailPracticedPrice;
    }
  }

  updateProductInCart({
    required SaleRequestProvider saleRequestProvider,
    required dynamic product,
  }) {
    double? controllerInDouble = double.tryParse(
      widget.textEditingController.text.replaceAll(RegExp(r'\,'), '.'),
    );

    bool? isValid = _formKey.currentState!.validate();

    if (controllerInDouble == null || controllerInDouble == 0) return;

    if (isValid) {
      saleRequestProvider.updateProductFromCart(
        enterpriseCode: widget.enterpriseCode.toString(),
        productPackingCode: product.ProductPackingCode,
        quantity: controllerInDouble,
        value: getPraticedPrice(
          minimumWholeQuantity: product.MinimumWholeQuantity,
          retailPracticedPrice: product.RetailPracticedPrice,
          wholePracticedPrice: product.WholePracticedPrice,
        ),
      );
      widget.textEditingController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider = Provider.of(context);
    double? controllerInDouble = double.tryParse(
      widget.textEditingController.text.replaceAll(RegExp(r'\,'), '.'),
    );

    int cartProductsCount =
        saleRequestProvider.cartProductsCount(widget.enterpriseCode.toString());

    var cartProducts =
        saleRequestProvider.getCartProducts(widget.enterpriseCode);

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: ListView.builder(
                itemCount: cartProductsCount,
                itemBuilder: (context, index) {
                  var product = cartProducts[index];

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          child: Column(
                            children: [
                              SaleRequestCartProductsItems
                                  .saleRequestCartProductsItems(
                                saleRequestProvider: saleRequestProvider,
                                changeFocus: () => changeFocus(
                                  saleRequestProvider: saleRequestProvider,
                                  index: index,
                                ),
                                context: context,
                                index: index,
                                product: product,
                                enterpriseCode: widget.enterpriseCode,
                                selectedIndex: _selectedIndex,
                              ),
                              if (_selectedIndex == index)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 55,
                                            child: InsertQuantityTextFormField(
                                              isLoading: saleRequestProvider
                                                  .isLoadingSaveSaleRequest,
                                              lengthLimitingTextInputFormatter:
                                                  8,
                                              focusNode: _focusNode,
                                              textEditingController:
                                                  widget.textEditingController,
                                              formKey: _formKey,
                                              onFieldSubmitted: () {
                                                ShowAlertDialog()
                                                    .showAlertDialog(
                                                  context: context,
                                                  title: "Atualizar o preço",
                                                  subtitle:
                                                      "Deseja realmente atualizar a quantidade e o preço?",
                                                  function: updateProductInCart(
                                                    saleRequestProvider:
                                                        saleRequestProvider,
                                                    product: product,
                                                  ),
                                                );
                                              },
                                              onChanged: () {
                                                setState(() {});
                                              },
                                              labelText:
                                                  "Digite a nova quantidade",
                                              hintText: "Nova quantidade",
                                            ),
                                          ),
                                          Expanded(
                                            flex: 45,
                                            child: Column(
                                              children: [
                                                const FittedBox(
                                                  child: Text(
                                                    " NOVO PREÇO",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  ),
                                                ),
                                                FittedBox(
                                                  child: Text(
                                                    getNewPrice(
                                                      minimumWholeQuantity: product
                                                          .MinimumWholeQuantity,
                                                      retailPracticedPrice: product
                                                          .RetailPracticedPrice,
                                                      wholePracticedPrice: product
                                                          .WholePracticedPrice,
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 55,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Preço venda: ${ConvertString.convertToBRL(product.RetailPracticedPrice)}",
                                                  style: hasMinimumWholeQuantity(
                                                      minimumWholeQuantity: product
                                                          .MinimumWholeQuantity,
                                                      isSaleRetailPrice: true),
                                                ),
                                                Text(
                                                  "Mín. atacado : ${product.MinimumWholeQuantity}",
                                                  style: hasMinimumWholeQuantity(
                                                      minimumWholeQuantity: product
                                                          .MinimumWholeQuantity),
                                                ),
                                                Text(
                                                  "Preço atacado: ${ConvertString.convertToBRL(product.WholePracticedPrice)}",
                                                  style: hasMinimumWholeQuantity(
                                                      minimumWholeQuantity: product
                                                          .MinimumWholeQuantity),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 45,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                fixedSize: const Size(300, 60),
                                              ),
                                              onPressed: controllerInDouble ==
                                                          null ||
                                                      controllerInDouble == 0
                                                  ? null
                                                  : () {
                                                      ShowAlertDialog()
                                                          .showAlertDialog(
                                                              context: context,
                                                              title:
                                                                  "Atualizar o preço",
                                                              subtitle:
                                                                  "Deseja realmente atualizar a quantidade e o preço?",
                                                              function: () {
                                                                updateProductInCart(
                                                                  saleRequestProvider:
                                                                      saleRequestProvider,
                                                                  product:
                                                                      product,
                                                                );

                                                                FocusScope.of(
                                                                        context)
                                                                    .unfocus();
                                                              });
                                                    },
                                              child: const Text("ATUALIZAR"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      if (index == cartProductsCount - 1 &&
                          cartProductsCount > 1)
                        TextButton(
                          onPressed:
                              saleRequestProvider.isLoadingSaveSaleRequest
                                  ? null
                                  : () {
                                      ShowAlertDialog().showAlertDialog(
                                        context: context,
                                        title: "Limpar carrinho",
                                        subtitle:
                                            "Deseja realmente limpar todos produtos do carrinho?",
                                        function: () {
                                          saleRequestProvider.clearCart(
                                              widget.enterpriseCode.toString());
                                        },
                                      );
                                    },
                          child: const Text(
                            "Limpar carrinho",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
