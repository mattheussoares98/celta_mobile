import 'package:celta_inventario/Components/Global_widgets/insert_quantity_textformfield.dart';
import 'package:celta_inventario/Models/transfer_request/transfer_request_products_model.dart';
import 'package:celta_inventario/providers/transfer_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/convert_string.dart';

class TransferRequestInsertProductQuantityForm extends StatefulWidget {
  final GlobalKey<FormState> consultedProductFormKey;
  final TextEditingController consultedProductController;
  final double totalItensInCart;
  final double totalItemValue;
  final TransferRequestProductsModel product;
  final Function addProductInCart;
  final Function updateTotalItemValue;
  const TransferRequestInsertProductQuantityForm({
    required this.consultedProductController,
    required this.consultedProductFormKey,
    required this.totalItensInCart,
    required this.totalItemValue,
    required this.product,
    required this.addProductInCart,
    required this.updateTotalItemValue,
    Key? key,
  }) : super(key: key);

  @override
  State<TransferRequestInsertProductQuantityForm> createState() =>
      _TransferRequestInsertProductQuantityFormState();
}

class _TransferRequestInsertProductQuantityFormState
    extends State<TransferRequestInsertProductQuantityForm> {
  addItemInCart() {
    bool isValid = widget.consultedProductFormKey.currentState!.validate();

    double? controllerInDouble = double.tryParse(
        widget.consultedProductController.text.replaceAll(RegExp(r'\,'), '.'));

    if (controllerInDouble == null) {
      //se não conseguir converter, é porque vai adicionar uma unidade
      controllerInDouble = 1;
    }

    if (isValid) {
      setState(() {
        widget.addProductInCart();
      });

      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    TransferRequestProvider transferRequestProvider =
        Provider.of(context, listen: true);

    double? quantityToAdd = double.tryParse(
        widget.consultedProductController.text.replaceAll(RegExp(r','), '.'));

    return Column(
      children: [
        const Divider(
          color: Colors.grey,
          height: 3,
        ),
        Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      if (quantityToAdd == null) return;

                      setState(() {
                        if (quantityToAdd! <= 1) {
                          widget.consultedProductController.text = "";
                          widget.consultedProductController.clear();
                        } else {
                          quantityToAdd = quantityToAdd! - 1;
                          widget.consultedProductController.text =
                              quantityToAdd!
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
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 10,
              child: InsertQuantityTextFormField(
                focusNode: transferRequestProvider.consultedProductFocusNode,
                textEditingController: widget.consultedProductController,
                formKey: widget.consultedProductFormKey,
                onChanged: () => {widget.updateTotalItemValue()},
                onFieldSubmitted: () => addItemInCart(),
                canReceiveEmptyValue: true,
                hintText: "Quantidade",
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              flex: 10,
              child: Container(
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.totalItemValue == 0
                        ? Colors.grey
                        : Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: widget.totalItemValue == 0
                      ? () {}
                      : () => addItemInCart(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 5),
                      Expanded(
                        flex: 10,
                        child: FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text("Total: "),
                              Text(
                                ConvertString.convertToBRL(
                                  widget.totalItemValue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        flex: 8,
                        child: FittedBox(
                          child: Row(
                            children: [
                              Text(
                                quantityToAdd == null
                                    ? "ADICIONAR +1"
                                    : "ADICIONAR",
                                style: const TextStyle(fontSize: 17),
                              ),
                              const Icon(
                                Icons.shopping_cart,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
