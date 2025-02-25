import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/models.dart';
import '../../../../providers/providers.dart';
import '../../../../utils/utils.dart';
import '../../../../components/components.dart';
import '../components.dart';

class ProductsItems extends StatefulWidget {
  final Function getProductsWithCamera;

  const ProductsItems({
    required this.getProductsWithCamera,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductsItems> createState() => _ProductsItemsState();
}

class _ProductsItemsState extends State<ProductsItems> {
  int selectedIndex = -1;
  final _consultedProductFormKey = GlobalKey<FormState>();
  final quantityFocusNode = FocusNode();
  final quantityController = TextEditingController();
  final newPriceFocusNode = FocusNode();
  final newPriceController = TextEditingController();
  final priceKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    quantityFocusNode.dispose();
    quantityController.dispose();
    newPriceFocusNode.dispose();
    newPriceController.dispose();
  }

  void changeCursorToLastIndex() {
    quantityController.selection = TextSelection.collapsed(
      offset: quantityController.text.length,
    );
  }

  void changeFocus(
    TransferRequestProvider transferRequestProvider,
    int index,
    GetProductJsonModel product,
  ) {
    if (selectedIndex == index) {
      setState(() {
        selectedIndex = -1;
      });
      return;
    }

    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    TransferRequestModel selectedTransferRequestModel =
        arguments["selectedTransferRequestModel"];

    if (product.value == 0 &&
        selectedTransferRequestModel.AllowAlterCostOrSalePrice != true) {
      ShowSnackbarMessage.show(
        message:
            "O preço está zerado e o modelo de pedido não permite a alteração do preço. Por isso não é possível inserir a quantidade!",
        context: context,
      );
      return;
    }

    if (selectedIndex != index) {
      quantityController.text = "1,000";
      newPriceController.text =
          product.value.toString().toDouble().toString().toBrazilianNumber();

      setState(() {
        selectedIndex = index;
      });
    }
  }

  Future<void> insertUpdateProductInCart(
    TransferRequestModel selectedTransferRequestModel,
    double totalItemValue,
    TransferRequestProvider transferRequestProvider,
    GetProductJsonModel product,
    TransferRequestEnterpriseModel destinyEnterprise,
    TransferRequestEnterpriseModel originEnterprise,
    ConfigurationsProvider configurationsProvider,
  ) async {
    if (newPriceFocusNode.hasFocus && totalItemValue == 0) {
      ShowSnackbarMessage.show(
        message: "O total dos itens está zerado!",
        context: context,
      );
      Future.delayed(Duration.zero, () {
        newPriceFocusNode.requestFocus();
        newPriceController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: newPriceController.text.length,
        );
      });
    } else if (selectedTransferRequestModel.AllowAlterCostOrSalePrice == true &&
        totalItemValue == 0) {
      Future.delayed(Duration.zero, () {
        newPriceFocusNode.requestFocus();
        newPriceController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: newPriceController.text.length,
        );
      });
    } else if (totalItemValue == 0) {
      ShowSnackbarMessage.show(
        message: "O total dos itens está zerado!",
        context: context,
      );
    } else {
      await transferRequestProvider.insertUpdateProductInCart(
        newPriceController: newPriceController,
        quantityController: quantityController,
        product: product,
        enterpriseOriginCode: originEnterprise.Code.toString(),
        enterpriseDestinyCode: destinyEnterprise.Code.toString(),
        requestTypeCode: selectedTransferRequestModel.Code.toString(),
      );
      setState(() {
        selectedIndex = -1;
      });

      if (configurationsProvider.autoScan?.value == true) {
        await widget.getProductsWithCamera();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TransferRequestProvider transferRequestProvider = Provider.of(context);
    ConfigurationsProvider configurationsProvider = Provider.of(context);
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    TransferRequestModel selectedTransferRequestModel =
        arguments["selectedTransferRequestModel"];
    TransferRequestEnterpriseModel destinyEnterprise =
        arguments["destinyEnterprise"];
    TransferRequestEnterpriseModel originEnterprise =
        arguments["originEnterprise"];

    if (transferRequestProvider.products.isEmpty) {
      selectedIndex = -1;
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transferRequestProvider.products.length,
      itemBuilder: (context, index) {
        GetProductJsonModel product = transferRequestProvider.products[index];

        if (transferRequestProvider.products.isEmpty) return Container();

        double _totalItensInCart = transferRequestProvider.getTotalItensInCart(
          ProductPackingCode: product.productPackingCode,
          enterpriseOriginCode: originEnterprise.Code.toString(),
          enterpriseDestinyCode: destinyEnterprise.Code.toString(),
          requestTypeCode: selectedTransferRequestModel.Code.toString(),
        );

        double _totalItemValue = transferRequestProvider.getTotalItemValue(
          product: product,
          consultedProductController: quantityController,
          newPriceController: newPriceController,
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                changeFocus(transferRequestProvider, index, product);
              },
              child: Column(
                children: [
                  ProductItem(
                    showCosts: false,
                    showPrice: true,
                    showLastBuyEntrance: true,
                    showMargins: false,
                    showWholeInformations: false,
                    product: product,
                    enterpriseCode: originEnterprise.Code,
                    componentAfterProductInformations: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Column(
                        children: [
                          if (transferRequestProvider.alreadyContainsProduct(
                            ProductPackingCode: product.productPackingCode,
                            enterpriseOriginCode:
                                originEnterprise.Code.toString(),
                            enterpriseDestinyCode:
                                destinyEnterprise.Code.toString(),
                            requestTypeCode:
                                selectedTransferRequestModel.Code.toString(),
                          ))
                            QuantityInCartAndRemoveProduct(
                              product: product,
                              originEnterprise: originEnterprise,
                              destinyEnterprise: destinyEnterprise,
                              selectedTransferRequestModel:
                                  selectedTransferRequestModel,
                            ),
                          if (selectedIndex == index)
                            InsertProductQuantityForm(
                              selectedTransferRequestModel:
                                  selectedTransferRequestModel,
                              quantityFocusNode: quantityFocusNode,
                              consultedProductController: quantityController,
                              consultedProductFormKey: _consultedProductFormKey,
                              totalItemValue: _totalItemValue,
                              product: product,
                              addProductInCart: () async {
                                await insertUpdateProductInCart(
                                  selectedTransferRequestModel,
                                  _totalItemValue,
                                  transferRequestProvider,
                                  product,
                                  destinyEnterprise,
                                  originEnterprise,
                                  configurationsProvider,
                                );
                              },
                              totalItensInCart: _totalItensInCart,
                              updateTotalItemValue: () {
                                setState(() {
                                  _totalItemValue =
                                      transferRequestProvider.getTotalItemValue(
                                    product: product,
                                    consultedProductController:
                                        quantityController,
                                    newPriceController: newPriceController,
                                  );
                                });
                              },
                            ),
                          if (selectedIndex == index &&
                              selectedTransferRequestModel
                                      .AllowAlterCostOrSalePrice ==
                                  true)
                            InsertQuantityTextFormField(
                              focusNode: newPriceFocusNode,
                              newQuantityController: newPriceController,
                              formKey: priceKey,
                              onChanged: (_) {
                                setState(() {});
                              },
                              onFieldSubmitted: (_) async {
                                await insertUpdateProductInCart(
                                  selectedTransferRequestModel,
                                  _totalItemValue,
                                  transferRequestProvider,
                                  product,
                                  destinyEnterprise,
                                  originEnterprise,
                                  configurationsProvider,
                                );
                              },
                              autoFocus: false,
                              canReceiveEmptyValue: false,
                              enabled: true,
                              hintText: "Alterar preço R\$",
                              labelText: "Alterar preço R\$",
                              showSuffixIcon: false,
                              showPrefixIcon: false,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
