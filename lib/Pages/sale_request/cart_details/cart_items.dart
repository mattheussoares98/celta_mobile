import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/models.dart';
import '../../../providers/providers.dart';
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

class _CartItemsState extends State<CartItems> {
  int _selectedIndex = -1;
  GlobalKey<FormState> _quantityFormKey = GlobalKey<FormState>();
  FocusNode _quantityFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _quantityFocusNode.dispose();
  }

  void changeFocusToConsultedProductFocusNode({
    required SaleRequestProvider saleRequestProvider,
  }) {
    Future.delayed(const Duration(milliseconds: 300), () {
      //se não colocar em um future pra mudar o foco,
      //não funciona corretamente
      FocusScope.of(context).requestFocus(
        _quantityFocusNode,
      );
    });
  }

  void selectIndexAndFocus({
    required int index,
    required SaleRequestProvider saleRequestProvider,
  }) async {
    if (_selectedIndex != index) {
      widget.newQuantityController.text = "";
      widget.newQuantityController.clear();

      setState(() {
        _selectedIndex = index;
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        FocusScope.of(context).requestFocus(
          _quantityFocusNode,
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

    bool? isValid = _quantityFormKey.currentState!.validate();

    if (controllerInDouble == null || controllerInDouble == 0) return;

    if (isValid) {
      saleRequestProvider.updateProductFromCart(
        enterpriseCode: widget.enterpriseCode.toString(),
        productPackingCode: product.productPackingCode!,
        quantity: controllerInDouble,
        updateToNeedProcessCartAgain: false,
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
                  InkWell(
                    onTap: () {
                      selectIndexAndFocus(
                        index: index,
                        saleRequestProvider: saleRequestProvider,
                      );
                    },
                    child: Column(
                      children: [
                        ProductInformations(
                          index: index,
                          product: product,
                          enterpriseCode: widget.enterpriseCode,
                          selectedIndex: _selectedIndex,
                        ),
                        QuantitysAndPrices(
                          product: product,
                          selectedIndex: _selectedIndex,
                          changeFocus: () {
                            selectIndexAndFocus(
                              saleRequestProvider: saleRequestProvider,
                              index: index,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  if (_selectedIndex == index)
                    UpdateQuantity(
                      product: product,
                      controllerInDouble: controllerInDouble,
                      callSetState: () {
                        setState(() {});
                      },
                      updateProductInCart: () {
                        updateProductInCart(
                          saleRequestProvider: saleRequestProvider,
                          product: product,
                          index: index,
                        );
                      },
                      quantityFocusNode: _quantityFocusNode,
                      quantityFormKey: _quantityFormKey,
                      newQuantityController: widget.newQuantityController,
                      enterpriseCode: widget.enterpriseCode,
                    ),
                ],
              ),
            ),
            if (index == cartProductsCount - 1 && cartProductsCount > 1)
              ClearCart(enterpriseCode: widget.enterpriseCode),
          ],
        );
      },
    );
  }
}
