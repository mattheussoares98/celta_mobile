import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../models/soap/soap.dart';
import '../../../pages/sale_request/sale_request.dart';

class InsertProductQuantityForm extends StatefulWidget {
  final GlobalKey<FormState> consultedProductFormKey;
  final TextEditingController searchProductController;
  final FocusNode insertQuantityFocusNode;
  final double totalItensInCart;
  final double totalItemValue;
  final GetProductJsonModel product;
  final Function addProductInCart;
  final Function updateTotalItemValue;
  final int enterpriseCode;
  const InsertProductQuantityForm({
    required this.searchProductController,
    required this.insertQuantityFocusNode,
    required this.enterpriseCode,
    required this.consultedProductFormKey,
    required this.totalItensInCart,
    required this.totalItemValue,
    required this.product,
    required this.addProductInCart,
    required this.updateTotalItemValue,
    Key? key,
  }) : super(key: key);

  @override
  State<InsertProductQuantityForm> createState() =>
      _InsertProductQuantityFormState();
}

class _InsertProductQuantityFormState extends State<InsertProductQuantityForm> {
  addItemInCart() {
    if (widget.searchProductController.text.isEmpty) {
      //não precisa validar o formulário se não houver quantidade adicionada porque o usuário vai adicionar uma quantidade
      setState(() {
        widget.addProductInCart();
      });

      FocusScope.of(context).unfocus();
      return;
    }
    bool isValid = widget.consultedProductFormKey.currentState!.validate();

    double? controllerInDouble = double.tryParse(
        widget.searchProductController.text.replaceAll(RegExp(r'\,'), '.'));

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
    double? quantityToAdd = double.tryParse(
        widget.searchProductController.text.replaceAll(RegExp(r','), '.'));

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
                          widget.searchProductController.text = "";
                          widget.searchProductController.clear();
                        } else {
                          quantityToAdd = quantityToAdd! - 1;
                          widget.searchProductController.text = quantityToAdd!
                              .toStringAsFixed(3)
                              .replaceAll(RegExp(r'\.'), ',');
                        }

                        widget.updateTotalItemValue();
                      });
                    },
                    icon: Icon(
                      Icons.remove,
                      color: widget.searchProductController.text.isEmpty
                          ? Colors.grey
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  IconButton(
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      if (widget.searchProductController.text.isEmpty ||
                          widget.searchProductController.text == "0") {
                        widget.searchProductController.text = "1,000";
                        widget.updateTotalItemValue();
                      } else {
                        double? quantityToAdd = double.tryParse(widget
                            .searchProductController.text
                            .replaceAll(RegExp(r','), '.'));

                        if (quantityToAdd != null) {
                          quantityToAdd++;

                          widget.searchProductController.text = quantityToAdd
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
              child: InsertQuantityTextFormField(
                focusNode: widget.insertQuantityFocusNode,
                textEditingController: widget.searchProductController,
                formKey: widget.consultedProductFormKey,
                onChanged: widget.updateTotalItemValue,
                onFieldSubmitted: addItemInCart,
                canReceiveEmptyValue: true,
                hintText: "Quantidade",
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: AddInCartButton(
                quantityToAdd: quantityToAdd,
                addItemInCart: addItemInCart,
                totalItemValue: widget.totalItemValue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
