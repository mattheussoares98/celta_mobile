import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../models/soap/soap.dart';
import '../../../providers/providers.dart';
import '../../../components/components.dart';

class InsertProductQuantity extends StatefulWidget {
  final GetProductJsonModel product;

  const InsertProductQuantity({
    required this.product,
    Key? key,
  }) : super(key: key);

  @override
  State<InsertProductQuantity> createState() =>
      _BuyRequestInsertProductQuantity();
}

class _BuyRequestInsertProductQuantity extends State<InsertProductQuantity> {
  bool _isValid() {
    BuyRequestProvider buyRequestProvider = Provider.of(context, listen: false);
    buyRequestProvider.insertQuantityFormKey.currentState!.validate();

    return buyRequestProvider.insertQuantityFormKey.currentState!.validate();
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

  void _updateProductInCart(GetProductJsonModel product) {
    BuyRequestProvider buyRequestProvider = Provider.of(context, listen: false);
    if (!_isValid()) {
      double? quantity = double.tryParse(
        buyRequestProvider.quantityController.text,
      );

      if (quantity == null) {
        FocusScope.of(context)
            .requestFocus(buyRequestProvider.quantityFocusNode);
      } else {
        FocusScope.of(context).requestFocus(buyRequestProvider.priceFocusNode);
      }
    } else {
      buyRequestProvider.updateProductInCart(product: product);
      buyRequestProvider.priceController.text = "";
      buyRequestProvider.quantityController.text = "";
      FocusScope.of(context).unfocus();
      buyRequestProvider.indexOfSelectedProduct = -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Form(
            key: buyRequestProvider.insertQuantityFormKey,
            child: Row(
              children: [
                Flexible(
                  flex: 10,
                  child: TextFormField(
                    // autofocus: true,
                    focusNode: buyRequestProvider.quantityFocusNode,
                    enabled: !buyRequestProvider.isLoadingProducts &&
                        !buyRequestProvider.isLoadingInsertBuyRequest,
                    controller: buyRequestProvider.quantityController,
                    inputFormatters: [LengthLimitingTextInputFormatter(7)],
                    onChanged: (value) => onChanged(
                      textController: buyRequestProvider.quantityController,
                      value: value,
                    ),
                    autovalidateMode: AutovalidateMode.always,
                    validator: (value) {
                      return FormFieldValidations.number(
                        value: value,
                        maxDecimalPlaces: 2,
                      );
                    },
                    decoration: FormFieldDecoration.decoration(
                      context: context,
                      labelText: 'Quantidade',
                    ),
                    onFieldSubmitted: (_) async {
                      if (buyRequestProvider.quantityController.text.isEmpty) {
                        FocusScope.of(context)
                            .requestFocus(buyRequestProvider.quantityFocusNode);
                      } else {
                        FocusScope.of(context)
                            .requestFocus(buyRequestProvider.priceFocusNode);
                        //seleciona todo o texto de preço
                        buyRequestProvider.priceController.selection =
                            TextSelection(
                          baseOffset: 0,
                          extentOffset:
                              buyRequestProvider.priceController.text.length,
                        );
                      }
                    },
                    style: FormFieldStyle.style(),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                    controller: buyRequestProvider.priceController,
                    inputFormatters: [LengthLimitingTextInputFormatter(10)],
                    onChanged: (value) => onChanged(
                      textController: buyRequestProvider.priceController,
                      value: value,
                    ),
                    validator: (value) => FormFieldValidations.number(
                      value: value,
                      maxDecimalPlaces: 4,
                    ),
                    decoration: FormFieldDecoration.decoration(
                      
                      context: context,
                      labelText: 'Custo',
                    ),
                    onFieldSubmitted: (_) async {
                      if (buyRequestProvider.priceController.text.isEmpty) {
                        FocusScope.of(context)
                            .requestFocus(buyRequestProvider.priceFocusNode);
                      } else {
                        _updateProductInCart(widget.product);
                      }
                    },
                    style: FormFieldStyle.style(),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                      _updateProductInCart(widget.product);
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
