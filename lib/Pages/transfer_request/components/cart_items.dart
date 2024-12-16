import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/transfer_request/transfer_request.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';
import '../../../components/components.dart';
import 'components.dart';

class CartItems extends StatefulWidget {
  final TextEditingController textEditingController;
  final String enterpriseOriginCode;
  final String enterpriseDestinyCode;
  final String requestTypeCode;
  const CartItems({
    required this.textEditingController,
    required this.enterpriseOriginCode,
    required this.enterpriseDestinyCode,
    required this.requestTypeCode,
    Key? key,
  }) : super(key: key);

  @override
  State<CartItems> createState() => _SaleRequestCartItemsState();
}

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _SaleRequestCartItemsState extends State<CartItems> {
  int _selectedIndex = -1;

  FocusNode _focusNode = FocusNode();

  changeFocusToConsultedProductFocusNode({
    required TransferRequestProvider transferRequestProvider,
  }) {
    Future.delayed(const Duration(milliseconds: 300), () {
      //se não colocar em um future pra mudar o foco,
      //não funciona corretamente
      FocusScope.of(context).requestFocus(
        _focusNode,
      );
    });
  }

  selectIndexAndFocus({
    required int index,
    required TransferRequestProvider transferRequestProvider,
  }) async {
    if (kIsWeb) {
      if (_selectedIndex != index) {
        setState(() {
          _selectedIndex = index;
          changeFocusToConsultedProductFocusNode(
            transferRequestProvider: transferRequestProvider,
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

  String getNewPrice({
    required TransferRequestCartProductsModel product,
  }) {
    double? controllerInDouble = double.tryParse(
        widget.textEditingController.text.replaceAll(RegExp(r'\,'), '.'));

    if (controllerInDouble == null) {
      return ConvertString.convertToBRL(0);
    }

    return ConvertString.convertToBRL(
      product.Value * controllerInDouble,
    );
  }

  updateProductInCart({
    required TransferRequestProvider transferRequestProvider,
    required TransferRequestCartProductsModel product,
    required int index,
  }) {
    double? controllerInDouble = double.tryParse(
      widget.textEditingController.text.replaceAll(RegExp(r'\,'), '.'),
    );

    bool? isValid = _formKey.currentState!.validate();

    if (controllerInDouble == null || controllerInDouble == 0) return;

    if (isValid) {
      transferRequestProvider.updateProductFromCart(
        enterpriseOriginCode: widget.enterpriseOriginCode,
        enterpriseDestinyCode: widget.enterpriseDestinyCode,
        requestTypeCode: widget.requestTypeCode,
        productPackingCode: product.ProductPackingCode,
        quantity: controllerInDouble,
        value: product.RetailPracticedPrice,
        index: index,
      );
      widget.textEditingController.clear();
      FocusScope.of(context).unfocus();
      _selectedIndex = -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    TransferRequestProvider transferRequestProvider = Provider.of(context);

    int cartProductsCount = transferRequestProvider.cartProductsCount(
      enterpriseOriginCode: widget.enterpriseOriginCode,
      enterpriseDestinyCode: widget.enterpriseDestinyCode,
      requestTypeCode: widget.requestTypeCode,
    );

    List<TransferRequestCartProductsModel> cartProducts =
        transferRequestProvider.getCartProducts(
      enterpriseOriginCode: widget.enterpriseOriginCode,
      enterpriseDestinyCode: widget.enterpriseDestinyCode,
      requestTypeCode: widget.requestTypeCode,
    );

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: ListView.builder(
                itemCount: cartProducts.length,
                itemBuilder: (context, index) {
                  final product = cartProducts[index];
                  double? controllerInDouble = double.tryParse(
                    widget.textEditingController.text
                        .replaceAll(RegExp(r'\,'), '.'),
                  );

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
                              CartProductsItems
                                  .transferRequestCartProductsItems(
                                updateSelectedIndex: () {
                                  setState(() {
                                    _selectedIndex = -1;
                                  });
                                },
                                enterpriseOriginCode:
                                    widget.enterpriseOriginCode,
                                enterpriseDestinyCode:
                                    widget.enterpriseDestinyCode,
                                requestTypeCode: widget.requestTypeCode,
                                transferRequestProvider:
                                    transferRequestProvider,
                                changeFocus: () => selectIndexAndFocus(
                                  index: index,
                                  transferRequestProvider:
                                      transferRequestProvider,
                                ),
                                context: context,
                                index: index,
                                product: product,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
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
                                                      ShowAlertDialog.show(
                                                          context: context,
                                                          title:
                                                              "Atualizar o preço",
                                                          content:
                                                              const SingleChildScrollView(
                                                            child: Text(
                                                              "Deseja realmente atualizar a quantidade e o preço?",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                          function: () {
                                                            updateProductInCart(
                                                              transferRequestProvider:
                                                                  transferRequestProvider,
                                                              product: product,
                                                              index: index,
                                                            );
                                                          });
                                                    },
                                              child: const Text("ATUALIZAR"),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 55,
                                            child: InsertQuantityTextFormField(
                                              lengthLimitingTextInputFormatter:
                                                  8,
                                              focusNode: _focusNode,
                                              newQuantityController:
                                                  widget.textEditingController,
                                              formKey: _formKey,
                                              onFieldSubmitted: () {
                                                ShowAlertDialog.show(
                                                  context: context,
                                                  title: "Atualizar o preço",
                                                  content:
                                                      const SingleChildScrollView(
                                                    child: Text(
                                                      "Deseja realmente atualizar a quantidade e o preço?",
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  function: () =>
                                                      updateProductInCart(
                                                    transferRequestProvider:
                                                        transferRequestProvider,
                                                    product: product,
                                                    index: index,
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
                                                      product: product,
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
                          onPressed: transferRequestProvider
                                  .isLoadingSaveTransferRequest
                              ? null
                              : () {
                                  ShowAlertDialog.show(
                                    context: context,
                                    title: "Limpar carrinho",
                                    content: const SingleChildScrollView(
                                      child: Text(
                                        "Deseja realmente limpar todos produtos do carrinho?",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    function: () {
                                      transferRequestProvider.clearCart(
                                        enterpriseOriginCode:
                                            widget.enterpriseOriginCode,
                                        enterpriseDestinyCode:
                                            widget.enterpriseDestinyCode,
                                        requestTypeCode: widget.requestTypeCode,
                                      );
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
