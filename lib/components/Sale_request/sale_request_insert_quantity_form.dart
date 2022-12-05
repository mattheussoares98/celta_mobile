import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../Models/sale_request_models/sale_request_products_model.dart';
import '../../utils/convert_string.dart';
import '../../utils/show_alert_dialog.dart';

class SaleRequestInsertQuantityForm extends StatefulWidget {
  final GlobalKey<FormState> consultedProductFormKey;
  final TextEditingController consultedProductController;
  final double totalItemQuantity;
  final double totalItemValue;
  final SaleRequestProductsModel product;
  final Function addProductInCart;
  final Function updateTotalItemValue;
  const SaleRequestInsertQuantityForm({
    required this.consultedProductController,
    required this.consultedProductFormKey,
    required this.totalItemQuantity,
    required this.product,
    required this.totalItemValue,
    required this.addProductInCart,
    required this.updateTotalItemValue,
    Key? key,
  }) : super(key: key);

  @override
  State<SaleRequestInsertQuantityForm> createState() =>
      _SaleRequestInsertQuantityFormState();
}

class _SaleRequestInsertQuantityFormState
    extends State<SaleRequestInsertQuantityForm> {
  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider =
        Provider.of(context, listen: true);
    return Column(
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
              key: widget.consultedProductFormKey,
              child: Expanded(
                child: TextFormField(
                  inputFormatters: [LengthLimitingTextInputFormatter(10)],
                  focusNode: saleRequestProvider.consultedProductFocusNode,
                  controller: widget.consultedProductController,
                  keyboardType: TextInputType.number,
                  onChanged: (text) {
                    widget.updateTotalItemValue();
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        style: BorderStyle.solid,
                        width: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(
                        right: 20,
                      ),
                      child: IconButton(
                        onPressed: () {
                          widget.consultedProductController.clear();
                          widget.updateTotalItemValue();
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
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                if (widget.consultedProductController.text.isEmpty ||
                    widget.consultedProductController.text == "0") {
                  widget.consultedProductController.text = "1,000";
                  widget.updateTotalItemValue();
                } else {
                  double? quantityToAdd = double.tryParse(widget
                      .consultedProductController.text
                      .replaceAll(RegExp(r','), '.'));

                  if (quantityToAdd != null) {
                    quantityToAdd++;

                    widget.consultedProductController.text = quantityToAdd
                        .toStringAsFixed(3)
                        .replaceAll(RegExp(r'\.'), ',');
                  }
                  widget.updateTotalItemValue();
                }
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: widget.consultedProductController.text.isEmpty &&
                            widget.totalItemQuantity > 0
                        ? Colors.red
                        : Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: widget.consultedProductController.text.isEmpty &&
                          widget.totalItemQuantity > 0
                      ? () {
                          ShowAlertDialog().showAlertDialog(
                            context: context,
                            title: "Confirmar exclusão",
                            subtitle: "Deseja excluir o produto do carrinho?",
                            function: () {
                              saleRequestProvider.removeProductFromCart(
                                widget.product.ProductPackingCode,
                              );

                              widget.updateTotalItemValue();
                            },
                          );
                        }
                      : () {
                          if (widget.consultedProductController.text.isEmpty ||
                              widget.consultedProductController.text == "0")
                            return;

                          widget.addProductInCart();
                        },
                  child: widget.consultedProductController.text.isEmpty &&
                          widget.totalItemQuantity > 0
                      ? const Text("Remover produto do carrinho")
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Text("Total"),
                                  Text(
                                    ConvertString.convertToBRL(
                                      widget.totalItemValue,
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
                                    style: TextStyle(fontSize: 17),
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
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                double? quantityToAdd = double.tryParse(widget
                    .consultedProductController.text
                    .replaceAll(RegExp(r','), '.'));
                if (quantityToAdd == null) return;

                setState(() {
                  if (quantityToAdd! <= 1) {
                    widget.consultedProductController.text = "";
                    widget.consultedProductController.clear();
                  } else {
                    quantityToAdd = quantityToAdd! - 1;
                    widget.consultedProductController.text = quantityToAdd!
                        .toStringAsFixed(3)
                        .replaceAll(RegExp(r'\.'), ',');
                  }

                  widget.updateTotalItemValue();
                });
              },
              icon: Icon(
                Icons.remove,
                color: widget.consultedProductController.text.isEmpty
                    ? Colors.grey
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
