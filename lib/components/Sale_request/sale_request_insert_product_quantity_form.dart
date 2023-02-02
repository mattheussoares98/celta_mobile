import 'package:celta_inventario/Components/Global_widgets/insert_quantity_textformfield.dart';
import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/sale_request_models/sale_request_products_model.dart';
import '../../utils/convert_string.dart';
import '../Global_widgets/show_alert_dialog.dart';

class SaleRequestInsertProductQuantityForm extends StatefulWidget {
  final GlobalKey<FormState> consultedProductFormKey;
  final TextEditingController consultedProductController;
  final double totalItensInCart;
  final double totalItemValue;
  final SaleRequestProductsModel product;
  final Function addProductInCart;
  final Function updateTotalItemValue;
  final int enterpriseCode;
  const SaleRequestInsertProductQuantityForm({
    required this.consultedProductController,
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
  State<SaleRequestInsertProductQuantityForm> createState() =>
      _SaleRequestInsertProductQuantityFormState();
}

class _SaleRequestInsertProductQuantityFormState
    extends State<SaleRequestInsertProductQuantityForm> {
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

  void removeProduct(SaleRequestProvider saleRequestProvider) {
    ShowAlertDialog().showAlertDialog(
      context: context,
      title: "Confirmar exclusão",
      subtitle: "Deseja excluir o produto do carrinho?",
      function: () {
        setState(() {
          saleRequestProvider.removeProductFromCart(
            ProductPackingCode: widget.product.ProductPackingCode,
            enterpriseCode: widget.enterpriseCode.toString(),
          );

          widget.updateTotalItemValue();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider =
        Provider.of(context, listen: true);

    double? quantityToAdd = double.tryParse(
        widget.consultedProductController.text.replaceAll(RegExp(r','), '.'));

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
            Expanded(
              child: InsertQuantityTextFormField(
                focusNode: saleRequestProvider.consultedProductFocusNode,
                textEditingController: widget.consultedProductController,
                formKey: widget.consultedProductFormKey,
                onChanged: () => {widget.updateTotalItemValue()},
                onFieldSubmitted: () => addItemInCart(),
                canReceiveEmptyValue: true,
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
              flex: 3,
              child: TextButton(
                style: TextButton.styleFrom(
                  primary:
                      widget.totalItensInCart > 0 ? Colors.red : Colors.grey,
                ),
                onPressed: widget.totalItensInCart > 0
                    ? () => removeProduct(saleRequestProvider)
                    : null,
                child: FittedBox(
                  child: Column(
                    children: [
                      const Text("Remover\nproduto"),
                      const Icon(Icons.delete),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              flex: 10,
              child: Container(
                height: 60,
                child: ElevatedButton(
                  onPressed: () => addItemInCart(),
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
            const SizedBox(width: 20),
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
