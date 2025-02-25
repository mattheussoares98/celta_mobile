import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/transfer_request/transfer_request.dart';
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
    required TransferRequestProductsModel product,
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
            ProductPackingCode: product.ProductPackingCode,
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
    TransferRequestProductsModel product,
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

    if (product.Value == 0 &&
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
          product.Value.toDouble().toString().toBrazilianNumber();

      setState(() {
        selectedIndex = index;
      });
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
        TransferRequestProductsModel product =
            transferRequestProvider.products[index];

        if (transferRequestProvider.products.isEmpty) return Container();

        double _totalItensInCart = transferRequestProvider.getTotalItensInCart(
          ProductPackingCode: product.ProductPackingCode,
          enterpriseOriginCode: originEnterprise.Code.toString(),
          enterpriseDestinyCode: destinyEnterprise.Code.toString(),
          requestTypeCode: selectedTransferRequestModel.Code.toString(),
        );

        double _totalItemValue = transferRequestProvider.getTotalItemValue(
          product: product,
          consultedProductController: quantityController,
          newPriceController: newPriceController,
        );

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                changeFocus(transferRequestProvider, index, product);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "PLU",
                    subtitle: product.PLU.toString(),
                    otherWidget: AllStocks.allStocks(
                      context: context,
                      hasStocks: product.Stocks.length > 0,
                      product: product,
                    ),
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Produto",
                    subtitle: product.Name.toString() +
                        " (${product.PackingQuantity})",
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Preço",
                    subtitle: ConvertString.convertToBRL(
                      product.Value,
                    ),
                    subtitleColor: Theme.of(context).colorScheme.primary,
                  ),
                  if (product.BalanceStockSale != null)
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "Estoque de venda",
                      subtitle: product.BalanceStockSale!
                          .toDouble()
                          .toString()
                          .toBrazilianNumber(),
                      otherWidget: Icon(
                        selectedIndex != index
                            ? Icons.arrow_drop_down_sharp
                            : Icons.arrow_drop_up_sharp,
                        color: Theme.of(context).colorScheme.primary,
                        size: 30,
                      ),
                    ),
                  if (transferRequestProvider.alreadyContainsProduct(
                    ProductPackingCode: product.ProductPackingCode,
                    enterpriseOriginCode: originEnterprise.Code.toString(),
                    enterpriseDestinyCode: destinyEnterprise.Code.toString(),
                    requestTypeCode:
                        selectedTransferRequestModel.Code.toString(),
                  ))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Qtd: " +
                                transferRequestProvider
                                    .getTotalItensInCart(
                                      ProductPackingCode:
                                          product.ProductPackingCode,
                                      enterpriseOriginCode:
                                          originEnterprise.Code.toString(),
                                      enterpriseDestinyCode:
                                          destinyEnterprise.Code.toString(),
                                      requestTypeCode:
                                          selectedTransferRequestModel.Code
                                              .toString(),
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
                                          originEnterprise.Code.toString(),
                                      enterpriseDestinyCode:
                                          destinyEnterprise.Code.toString(),
                                      requestTypeCode:
                                          selectedTransferRequestModel.Code
                                              .toString(),
                                    )
                                : null,
                            child: const FittedBox(
                              child: Row(
                                children: [
                                  Text(
                                    "Remover produto",
                                    style: TextStyle(color: Colors.white),
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
                      selectedTransferRequestModel: selectedTransferRequestModel,
                      quantityFocusNode: quantityFocusNode,
                      consultedProductController: quantityController,
                      consultedProductFormKey: _consultedProductFormKey,
                      totalItemValue: _totalItemValue,
                      product: product,
                      addProductInCart: () async {
                        if (_totalItemValue == 0) {
                          ShowSnackbarMessage.show(
                            message: "O total dos itens está zerado!",
                            context: context,
                          );
                        }
                        await transferRequestProvider.addProductInCart(
                          newPriceController: newPriceController,
                          consultedProductController: quantityController,
                          product: product,
                          enterpriseOriginCode:
                              originEnterprise.Code.toString(),
                          enterpriseDestinyCode:
                              destinyEnterprise.Code.toString(),
                          requestTypeCode:
                              selectedTransferRequestModel.Code.toString(),
                        );
                        setState(() {
                          selectedIndex = -1;
                        });

                        if (configurationsProvider.autoScan?.value == true) {
                          await widget.getProductsWithCamera();
                        }
                      },
                      totalItensInCart: _totalItensInCart,
                      updateTotalItemValue: () {
                        setState(() {
                          _totalItemValue =
                              transferRequestProvider.getTotalItemValue(
                            product: product,
                            consultedProductController: quantityController,
                            newPriceController: newPriceController,
                          );
                        });
                      },
                    ),
                  if (selectedIndex == index &&
                      selectedTransferRequestModel.AllowAlterCostOrSalePrice ==
                          true)
                    InsertQuantityTextFormField(
                      focusNode: newPriceFocusNode,
                      newQuantityController: newPriceController,
                      formKey: priceKey,
                      onChanged: () {
                        setState(() {});
                      },
                      onFieldSubmitted: () {},
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
        );
      },
    );
  }
}
