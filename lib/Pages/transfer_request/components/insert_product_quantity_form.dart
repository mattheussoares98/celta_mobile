import 'package:flutter/material.dart';

import '../../../models/models.dart';

import '../../../utils/utils.dart';
import '../../../components/components.dart';

class InsertProductQuantityForm extends StatefulWidget {
  final GlobalKey<FormState> consultedProductFormKey;
  final TextEditingController consultedProductController;
  final TransferRequestModel selectedTransferRequestModel;
  final FocusNode quantityFocusNode;
  final double totalItensInCart;
  final double totalItemValue;
  final TransferRequestProductsModel product;
  final void Function() addProductInCart;
  final void Function() updateTotalItemValue;
  const InsertProductQuantityForm({
    required this.consultedProductController,
    required this.consultedProductFormKey,
    required this.quantityFocusNode,
    required this.totalItensInCart,
    required this.totalItemValue,
    required this.product,
    required this.addProductInCart,
    required this.updateTotalItemValue,
    required this.selectedTransferRequestModel,
    Key? key,
  }) : super(key: key);

  @override
  State<InsertProductQuantityForm> createState() =>
      _InsertProductQuantityFormState();
}

class _InsertProductQuantityFormState extends State<InsertProductQuantityForm> {
  void addItemInCart() {
    if (widget.consultedProductController.text.isEmpty) {
      //não precisa validar o formulário se não houver quantidade adicionada porque o usuário vai adicionar uma quantidade
      setState(() {
        widget.addProductInCart();
      });

      FocusScope.of(context).unfocus();
      return;
    }

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
    double? quantityToAdd = double.tryParse(
        widget.consultedProductController.text.replaceAll(RegExp(r','), '.'));

    return Column(
      children: [
        const Divider(
          color: Colors.grey,
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              flex: 10,
              child: InsertQuantityTextFormField(
                autoFocus: true,
                enabled: widget.product.Value > 0 ||
                    widget.selectedTransferRequestModel
                            .AllowAlterCostOrSalePrice ==
                        true,
                focusNode: widget.quantityFocusNode,
                newQuantityController: widget.consultedProductController,
                formKey: widget.consultedProductFormKey,
                onChanged: widget.updateTotalItemValue,
                onFieldSubmitted: addItemInCart,
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
                  onPressed: widget.totalItemValue == 0 ? null : addItemInCart,
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
