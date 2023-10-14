import 'package:celta_inventario/Components/Global_widgets/insert_quantity_textformfield.dart';
import 'package:celta_inventario/components/Transfer_request/transfer_request_cart_products_items.dart';
import 'package:celta_inventario/providers/transfer_request_provider.dart';
import 'package:celta_inventario/utils/convert_string.dart';
import 'package:celta_inventario/Components/Global_widgets/show_alert_dialog.dart';
import 'package:celta_inventario/utils/responsive_items.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/transfer_request/transfer_request_cart_products_model.dart';

class TransferRequestCartItems extends StatefulWidget {
  final TextEditingController textEditingController;
  final String enterpriseOriginCode;
  final String enterpriseDestinyCode;
  final String requestTypeCode;
  const TransferRequestCartItems({
    required this.textEditingController,
    required this.enterpriseOriginCode,
    required this.enterpriseDestinyCode,
    required this.requestTypeCode,
    Key? key,
  }) : super(key: key);

  @override
  State<TransferRequestCartItems> createState() => _SaleRequestCartItemsState();
}

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _SaleRequestCartItemsState extends State<TransferRequestCartItems> {
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

  Widget itemOfList({
    required int index,
    required TransferRequestProvider transferRequestProvider,
  }) {
    List<TransferRequestCartProductsModel> products =
        transferRequestProvider.getCartProducts(
      enterpriseOriginCode: widget.enterpriseOriginCode,
      enterpriseDestinyCode: widget.enterpriseDestinyCode,
      requestTypeCode: widget.requestTypeCode,
    );

    TransferRequestCartProductsModel product = products[index];

    double? controllerInDouble = double.tryParse(
      widget.textEditingController.text.replaceAll(RegExp(r'\,'), '.'),
    );

    return Padding(
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
            TransferRequestCartProductsItems.transferRequestCartProductsItems(
              updateSelectedIndex: () {
                setState(() {
                  _selectedIndex = -1;
                });
              },
              enterpriseOriginCode: widget.enterpriseOriginCode,
              enterpriseDestinyCode: widget.enterpriseDestinyCode,
              requestTypeCode: widget.requestTypeCode,
              transferRequestProvider: transferRequestProvider,
              changeFocus: () => selectIndexAndFocus(
                index: index,
                transferRequestProvider: transferRequestProvider,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 45,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(300, 60),
                            ),
                            onPressed: controllerInDouble == null ||
                                    controllerInDouble == 0
                                ? null
                                : () {
                                    ShowAlertDialog.showAlertDialog(
                                        context: context,
                                        title: "Atualizar o preço",
                                        subtitle:
                                            "Deseja realmente atualizar a quantidade e o preço?",
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
                            isLoading: transferRequestProvider
                                .isLoadingSaveTransferRequest,
                            lengthLimitingTextInputFormatter: 8,
                            focusNode: _focusNode,
                            textEditingController: widget.textEditingController,
                            formKey: _formKey,
                            onFieldSubmitted: () {
                              ShowAlertDialog.showAlertDialog(
                                context: context,
                                title: "Atualizar o preço",
                                subtitle:
                                    "Deseja realmente atualizar a quantidade e o preço?",
                                function: () => updateProductInCart(
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
                            labelText: "Digite a nova quantidade",
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
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
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
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
    );
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

    int itensPerLine = ResponsiveItems.getItensPerLine(context);

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
                  final startIndex = index * itensPerLine;
                  final endIndex =
                      (startIndex + itensPerLine <= cartProducts.length)
                          ? startIndex + itensPerLine
                          : cartProducts.length;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var i = startIndex; i < endIndex; i++)
                            Expanded(
                              child: itemOfList(
                                index: i,
                                transferRequestProvider:
                                    transferRequestProvider,
                              ),
                            ),
                        ],
                      ),
                      if (index == cartProductsCount - 1 &&
                          cartProductsCount > 1)
                        TextButton(
                          onPressed: transferRequestProvider
                                  .isLoadingSaveTransferRequest
                              ? null
                              : () {
                                  ShowAlertDialog.showAlertDialog(
                                    context: context,
                                    title: "Limpar carrinho",
                                    subtitle:
                                        "Deseja realmente limpar todos produtos do carrinho?",
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
