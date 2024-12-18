import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/soap/soap.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';
import '../../../components/components.dart';
import 'cart_details.dart';

class CartItems extends StatefulWidget {
  final TextEditingController newQuantityController;
  final int enterpriseCode;
  const CartItems({
    required this.newQuantityController,
    required this.enterpriseCode,
    Key? key,
  }) : super(key: key);

  @override
  State<CartItems> createState() => _CartItemsState();
}

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _CartItemsState extends State<CartItems> {
  int _selectedIndex = -1;

  FocusNode _focusNode = FocusNode();

  void changeFocusToConsultedProductFocusNode({
    required SaleRequestProvider saleRequestProvider,
  }) {
    Future.delayed(const Duration(milliseconds: 300), () {
      //se não colocar em um future pra mudar o foco,
      //não funciona corretamente
      FocusScope.of(context).requestFocus(
        _focusNode,
      );
    });
  }

  void selectIndexAndFocus({
    required int index,
    required SaleRequestProvider saleRequestProvider,
  }) async {
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
      widget.newQuantityController.text = "";
      widget.newQuantityController.clear();

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

  void updateProductInCart({
    required SaleRequestProvider saleRequestProvider,
    required GetProductJsonModel product,
    required int index,
  }) {
    double? controllerInDouble = double.tryParse(
      widget.newQuantityController.text.replaceAll(RegExp(r'\,'), '.'),
    );

    bool? isValid = _formKey.currentState!.validate();

    if (controllerInDouble == null || controllerInDouble == 0) return;

    if (isValid) {
      saleRequestProvider.updateProductFromCart(
        enterpriseCode: widget.enterpriseCode.toString(),
        productPackingCode: product.productPackingCode!,
        quantity: controllerInDouble,
        value: saleRequestProvider.getPracticedPrice(
          quantityToAdd: controllerInDouble,
          product: product,
          enterpriseCode: widget.enterpriseCode.toString(),
        ),
        index: index,
      );
      widget.newQuantityController.clear();
      _selectedIndex = -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider = Provider.of(context);

    int cartProductsCount =
        saleRequestProvider.cartProductsCount(widget.enterpriseCode.toString());

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: cartProductsCount,
      itemBuilder: (context, index) {
        var cartProducts =
            saleRequestProvider.getCartProducts(widget.enterpriseCode);
        GetProductJsonModel product = cartProducts[index];
        double? controllerInDouble = double.tryParse(
          widget.newQuantityController.text.replaceAll(RegExp(r'\,'), '.'),
        );

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Card(
              child: Column(
                children: [
                  CartProductsItems.saleRequestCartProductsItems(
                    updateSelectedIndex: () {
                      setState(() {
                        _selectedIndex = -1;
                      });
                    },
                    saleRequestProvider: saleRequestProvider,
                    changeFocus: () => selectIndexAndFocus(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 55,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TitleAndSubtitle.titleAndSubtitle(
                                      title: "Preço venda",
                                      subtitle: ConvertString.convertToBRL(
                                        product.retailPracticedPrice,
                                      ),
                                    ),
                                    TitleAndSubtitle.titleAndSubtitle(
                                      title: "Mín. atacado",
                                      subtitle: product.minimumWholeQuantity
                                          .toString()
                                          .toBrazilianNumber(),
                                    ),
                                    TitleAndSubtitle.titleAndSubtitle(
                                      title: "Preço atacado",
                                      subtitle: ConvertString.convertToBRL(
                                        product.wholePracticedPrice,
                                      ),
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
                                  onPressed: controllerInDouble == null ||
                                          controllerInDouble == 0
                                      ? null
                                      : () {
                                          ShowAlertDialog.show(
                                              context: context,
                                              title: "Atualizar o preço",
                                              content:
                                                  const SingleChildScrollView(
                                                child: Text(
                                                  "Deseja realmente atualizar a quantidade e o preço?",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              function: () {
                                                updateProductInCart(
                                                  saleRequestProvider:
                                                      saleRequestProvider,
                                                  product: product,
                                                  index: index,
                                                );

                                                FocusScope.of(context)
                                                    .unfocus();
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
                                  lengthLimitingTextInputFormatter: 8,
                                  focusNode: _focusNode,
                                  formKey: _formKey,
                                  newQuantityController:
                                      widget.newQuantityController,
                                  onFieldSubmitted: () {
                                    ShowAlertDialog.show(
                                      context: context,
                                      title: "Atualizar o preço",
                                      content: const SingleChildScrollView(
                                        child: Text(
                                          "Deseja realmente atualizar a quantidade e o preço?",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      function: () => updateProductInCart(
                                        saleRequestProvider:
                                            saleRequestProvider,
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
                                        saleRequestProvider
                                            .getNewPrice(
                                              product: product,
                                              enterpriseCode: widget
                                                  .enterpriseCode
                                                  .toString(),
                                              newQuantityController:
                                                  widget.newQuantityController,
                                            )
                                            .toString()
                                            .toBrazilianNumber()
                                            .addBrazilianCoin(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
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
            if (index == cartProductsCount - 1 && cartProductsCount > 1)
              TextButton(
                onPressed: saleRequestProvider.isLoadingSaveSaleRequest ||
                        saleRequestProvider.isLoadingProcessCart
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
                            saleRequestProvider
                                .clearCart(widget.enterpriseCode.toString());
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
    );
  }
}
