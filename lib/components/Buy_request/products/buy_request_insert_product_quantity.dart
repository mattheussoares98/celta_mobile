import 'package:celta_inventario/Models/buy_request_models/buy_request_product_model.dart';
import 'package:celta_inventario/components/Global_widgets/formfield_decoration.dart';
import 'package:celta_inventario/providers/buy_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class BuyRequestInsertProductQuantity extends StatefulWidget {
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final GlobalKey<FormState> insertQuantityFormKey;
  final BuyRequestProductsModel product;

  const BuyRequestInsertProductQuantity({
    required this.priceController,
    required this.insertQuantityFormKey,
    required this.quantityController,
    required this.product,
    Key? key,
  }) : super(key: key);

  @override
  State<BuyRequestInsertProductQuantity> createState() =>
      _BuyRequestInsertProductQuantity();
}

class _BuyRequestInsertProductQuantity
    extends State<BuyRequestInsertProductQuantity> {
  bool _isValid() {
    widget.insertQuantityFormKey.currentState!.validate();

    return widget.insertQuantityFormKey.currentState!.validate();
  }

  void onChanged({
    required String value,
    required TextEditingController textController,
  }) {
    if (value.isEmpty || value == '-') {
      value = '0';
    }
    if (value.startsWith(",") || value.startsWith(".")) {
      textController.text = "0" + textController.text;
      textController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: textController.text.length,
        ),
      );
    }
  }

  void updateProductInCart(BuyRequestProductsModel product) {
    if (!_isValid()) return;
    BuyRequestProvider buyRequestProvider = Provider.of(context, listen: false);
    buyRequestProvider.updateProductInCart(product: product);
    widget.priceController.text = "";
    widget.quantityController.text = "";
    FocusScope.of(context).unfocus();
    buyRequestProvider.indexOfSelectedProduct = -1;
  }

  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Form(
            key: widget.insertQuantityFormKey,
            child: Row(
              children: [
                Flexible(
                  flex: 10,
                  child: TextFormField(
                    // autofocus: true,
                    focusNode: buyRequestProvider.quantityFocusNode,
                    enabled: !buyRequestProvider.isLoadingProducts &&
                        !buyRequestProvider.isLoadingInsertBuyRequest,
                    controller: widget.quantityController,
                    inputFormatters: [LengthLimitingTextInputFormatter(7)],
                    onChanged: (value) => onChanged(
                      textController: widget.quantityController,
                      value: value,
                    ),
                    autovalidateMode: AutovalidateMode.always,
                    validator: FormFieldHelper.validatorOfNumber(),
                    decoration: FormFieldHelper.decoration(
                      isLoading: buyRequestProvider.isLoadingProducts,
                      context: context,
                      labelText: 'Quantidade',
                    ),
                    onFieldSubmitted: (_) async {
                      if (buyRequestProvider.quantityController.text.isEmpty ||
                          buyRequestProvider.quantityController.text == "") {
                        return;
                      }
                      FocusScope.of(context)
                          .requestFocus(buyRequestProvider.priceFocusNode);
                      //seleciona todo o texto de preço
                      buyRequestProvider.priceController.selection =
                          TextSelection(
                        baseOffset: 0,
                        extentOffset:
                            buyRequestProvider.priceController.text.length,
                      );
                    },
                    style: FormFieldHelper.style(),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 3),
                Flexible(
                  flex: 10,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.always,
                    focusNode: buyRequestProvider.priceFocusNode,
                    enabled: !buyRequestProvider.isLoadingProducts &&
                        !buyRequestProvider.isLoadingInsertBuyRequest,
                    controller: widget.priceController,
                    inputFormatters: [LengthLimitingTextInputFormatter(7)],
                    onChanged: (value) => onChanged(
                      textController: widget.priceController,
                      value: value,
                    ),
                    validator: FormFieldHelper.validatorOfNumber(),
                    decoration: FormFieldHelper.decoration(
                      isLoading: false,
                      context: context,
                      labelText: 'Preço',
                    ),
                    onFieldSubmitted: (_) async {
                      updateProductInCart(widget.product);
                    },
                    style: FormFieldHelper.style(),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 5),
                Flexible(
                  flex: 6,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      updateProductInCart(widget.product);
                    },
                    child: const FittedBox(
                      child: Text(
                        "ATUALIZAR",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
