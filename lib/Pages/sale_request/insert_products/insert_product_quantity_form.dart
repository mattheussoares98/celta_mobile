import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../models/soap/soap.dart';
import '../../../pages/sale_request/sale_request.dart';

class InsertProductQuantityForm extends StatefulWidget {
  final GlobalKey<FormState> consultedProductFormKey;
  final TextEditingController newQuantityController;
  final FocusNode insertQuantityFocusNode;
  final double totalItensInCart;
  final double totalItemValue;
  final GetProductJsonModel product;
  final void Function() addProductInCart;
  final void Function() updateTotalItemValue;
  final int enterpriseCode;
  const InsertProductQuantityForm({
    required this.newQuantityController,
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
    if (widget.newQuantityController.text.isEmpty) {
      //não precisa validar o formulário se não houver quantidade adicionada porque o usuário vai adicionar uma quantidade
      setState(() {
        widget.addProductInCart();
      });

      FocusScope.of(context).unfocus();
      return;
    }
    bool isValid = widget.consultedProductFormKey.currentState!.validate();

    double? controllerInDouble = double.tryParse(
        widget.newQuantityController.text.replaceAll(RegExp(r'\,'), '.'));

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
    return Column(
      children: [
        const Divider(
          color: Colors.grey,
          height: 3,
        ),
        Row(
          children: [
            Expanded(
              child: MoreOrLessQuantityButtons(
                newQuantityController: widget.newQuantityController,
                updateTotalItemValue: widget.updateTotalItemValue,
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
                newQuantityController: widget.newQuantityController,
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
                newQuantityController: widget.newQuantityController,
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
