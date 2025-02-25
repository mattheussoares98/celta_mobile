import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../models/models.dart';
import '../../../../providers/providers.dart';
import '../../../../utils/utils.dart';

class EditQuantityAndPrice extends StatefulWidget {
  final TransferRequestModel selectedTransferRequestModel;
  final void Function() unselectIndex;
  final TransferRequestEnterpriseModel originEnterprise;
  final TransferRequestEnterpriseModel destinyEnterprise;
  final TransferRequestCartProductsModel product;
  const EditQuantityAndPrice({
    required this.selectedTransferRequestModel,
    required this.unselectIndex,
    required this.originEnterprise,
    required this.destinyEnterprise,
    required this.product,
    super.key,
  });

  @override
  State<EditQuantityAndPrice> createState() => _EditQuantityAndPriceState();
}

class _EditQuantityAndPriceState extends State<EditQuantityAndPrice> {
  final quantityFormKey = GlobalKey<FormState>();
  final priceFormKey = GlobalKey<FormState>();
  final quantityFocusNode = FocusNode();
  final quantityController = TextEditingController();
  final priceFocusNode = FocusNode();
  final priceController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    quantityFocusNode.dispose();
    quantityController.dispose();
    priceFocusNode.dispose();
    priceController.dispose();
  }

  Future<void> updateProductInCart({
    required TransferRequestProvider transferRequestProvider,
    required TransferRequestCartProductsModel product,
    required int index,
  }) async {
    double quantity = quantityController.text.toDouble();

    bool? isValid = quantityFormKey.currentState?.validate();

    if (quantity <= 0) return;

    if (isValid == true) {
      await transferRequestProvider.updateProductFromCart(
        enterpriseOriginCode: widget.originEnterprise.Code.toString(),
        enterpriseDestinyCode: widget.destinyEnterprise.Code.toString(),
        requestTypeCode: widget.selectedTransferRequestModel.Code.toString(),
        productPackingCode: product.ProductPackingCode,
        quantity: quantity,
        value: product.RetailPracticedPrice,
        index: index,
      );
      quantityController.clear();
      FocusScope.of(context).unfocus();
      widget.unselectIndex();
    }
  }

  double getNewPrice() {
    final quantity = quantityController.text.toDouble();

    if (quantity <= 0) {
      return 0;
    } else if (widget.selectedTransferRequestModel.AllowAlterCostOrSalePrice !=
        true) {
      return quantity * widget.product.Value;
    } else {
      final price = priceController.text.toDouble();
      if (price <= 0) return 0;

      return quantity * priceController.text.toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    TransferRequestProvider transferRequestProvider = Provider.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          InsertQuantityTextFormField(
            focusNode: quantityFocusNode,
            newQuantityController: quantityController,
            formKey: quantityFormKey,
            onChanged: () {
              setState(() {});
            },
            onFieldSubmitted: () {},
          ),
          if (widget.selectedTransferRequestModel.AllowAlterCostOrSalePrice ==
              true)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: InsertQuantityTextFormField(
                showPrefixIcon: false,
                showSuffixIcon: false,
                focusNode: priceFocusNode,
                newQuantityController: priceController,
                formKey: priceFormKey,
                hintText: "Preço R\$",
                labelText: "Preço R\$",
                onChanged: () {
                  setState(() {});
                },
                onFieldSubmitted: () {},
              ),
            ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text("Novo preço"),
                    Text(
                      getNewPrice()
                          .toString()
                          .toBrazilianNumber()
                          .addBrazilianCoin(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: getNewPrice() <= 0
                      ? null
                      : () async {
                          //TODO fix this
                          // await transferRequestProvider
                          //     .insertUpdateProductInCart(
                          //   product: widget.product,
                          //   quantityController: quantityController,
                          //   newPriceController: priceController,
                          //   enterpriseOriginCode:
                          //       widget.originEnterprise.Code.toString(),
                          //   enterpriseDestinyCode:
                          //       widget.destinyEnterprise.Code.toString(),
                          //   requestTypeCode: widget
                          //       .selectedTransferRequestModel.Code
                          //       .toString(),
                          // );
                        },
                  child: FittedBox(child: Text("Alterar preço")),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
