import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/models.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';
import '../../../components/components.dart';
import 'components.dart';

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

  void removeProduct({
    required TransferRequestProvider transferRequestProvider,
    required double totalItemValue,
    required GetProductJsonModel product,
    required String enterpriseDestinyCode,
    required String enterpriseOriginCode,
    required String requestTypeCode,
  }) {
    ShowAlertDialog.show(
      context: context,
      title: "Confirmar exclusão",
      content: const SingleChildScrollView(
        child: Text(
          "Deseja excluir o produto do carrinho?",
          textAlign: TextAlign.center,
        ),
      ),
      function: () {
        setState(() {
          transferRequestProvider.removeProductFromCart(
            ProductPackingCode: product.productPackingCode,
            enterpriseDestinyCode: enterpriseDestinyCode,
            enterpriseOriginCode: enterpriseOriginCode,
            requestTypeCode: requestTypeCode,
          );

          totalItemValue = transferRequestProvider.getTotalItemValue(
            product: product,
            consultedProductController: quantityController,
            newPriceController: newPriceController,
          );
        });
      },
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
//TODO when search product, remove selected index
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
                    componentAfterProductInformations: _totalItensInCart == 0
                        ? null
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Qtd: " +
                                          transferRequestProvider
                                              .getTotalItensInCart(
                                                ProductPackingCode:
                                                    product.productPackingCode,
                                                enterpriseOriginCode:
                                                    originEnterprise.Code
                                                        .toString(),
                                                enterpriseDestinyCode:
                                                    destinyEnterprise.Code
                                                        .toString(),
                                                requestTypeCode:
                                                    selectedTransferRequestModel
                                                        .Code.toString(),
                                              )
                                              .toStringAsFixed(3)
                                              .replaceAll(RegExp(r'\.'), ','),
                                      style: TextStyle(
                                        color: _totalItensInCart > 0
                                            ? Colors.red
                                            : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        // primary: _totalItensInCart > 0
                                        //     ? Colors.red
                                        //     : Colors.grey,
                                      ),
                                      onPressed: _totalItensInCart > 0
                                          ? () => removeProduct(
                                                transferRequestProvider:
                                                    transferRequestProvider,
                                                totalItemValue: _totalItemValue,
                                                product: product,
                                                enterpriseOriginCode:
                                                    originEnterprise.Code
                                                        .toString(),
                                                enterpriseDestinyCode:
                                                    destinyEnterprise.Code
                                                        .toString(),
                                                requestTypeCode:
                                                    selectedTransferRequestModel
                                                        .Code.toString(),
                                              )
                                          : null,
                                      child: const FittedBox(
                                        child: Row(
                                          children: [
                                            Text(
                                              "Remover produto",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (selectedIndex == index)
                                InsertProductQuantityForm(
                                  selectedTransferRequestModel:
                                      selectedTransferRequestModel,
                                  quantityFocusNode: quantityFocusNode,
                                  consultedProductController:
                                      quantityController,
                                  consultedProductFormKey:
                                      _consultedProductFormKey,
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
                                      _totalItemValue = transferRequestProvider
                                          .getTotalItemValue(
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
                                  onChanged: () {
                                    setState(() {});
                                  },
                                  onFieldSubmitted: () async {
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
                    //TODO dont show whole price. Dont show minimum whole quantity
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
