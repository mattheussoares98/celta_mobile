import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/transfer_request/transfer_request.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';
import '../../../components/components.dart';
import 'components.dart';

class ProductsItems extends StatefulWidget {
  final TextEditingController consultedProductController;
  final Function getProductsWithCamera;

  const ProductsItems({
    required this.getProductsWithCamera,
    required this.consultedProductController,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductsItems> createState() => _ProductsItemsState();
}

class _ProductsItemsState extends State<ProductsItems> {
  int selectedIndex = -1;

  GlobalKey<FormState> _consultedProductFormKey = GlobalKey();

  changeCursorToLastIndex() {
    widget.consultedProductController.selection = TextSelection.collapsed(
      offset: widget.consultedProductController.text.length,
    );
  }

  bool hasOneProductAndIsExpandedQuantityForm = false;
  //quando só retorna um produto na consulta, já expande a opção de inserção de
  //quantidade dos itens. Esse bool serve para saber quando já foi expandido uma
  //vez automaticamente o campo para digitação da quantidade, senão vai ficar
  //abrindo direto o campo para digitação, mesmo quando já inseriu a quantidade.

  void removeProduct({
    required TransferRequestProvider transferRequestProvider,
    required double totalItemValue,
    required dynamic product,
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
            consultedProductController: widget.consultedProductController,
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TransferRequestProvider transferRequestProvider = Provider.of(
      context,
      listen: true,
    );
    ConfigurationsProvider configurationsProvider = Provider.of(
      context,
      listen: true,
    );

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transferRequestProvider.productsCount,
      itemBuilder: (context, index) {
        if (transferRequestProvider.products.isEmpty) return Container();

        if (transferRequestProvider.productsCount == 1) {
          selectedIndex = 0;
        }

        Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

        TransferRequestProductsModel product =
            transferRequestProvider.products[index];

        double _totalItensInCart = transferRequestProvider.getTotalItensInCart(
          ProductPackingCode: product.ProductPackingCode,
          enterpriseOriginCode: arguments["enterpriseOriginCode"].toString(),
          enterpriseDestinyCode: arguments["enterpriseDestinyCode"].toString(),
          requestTypeCode: arguments["requestTypeCode"].toString(),
        );

        double _totalItemValue = transferRequestProvider.getTotalItemValue(
          product: product,
          consultedProductController: widget.consultedProductController,
        );

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: transferRequestProvider.isLoadingProducts
                  ? null
                  : () {
                      if (!transferRequestProvider
                              .consultedProductFocusNode.hasFocus &&
                          selectedIndex == index) {
                        Future.delayed(const Duration(milliseconds: 100), () {
                          FocusScope.of(context).requestFocus(
                            transferRequestProvider.consultedProductFocusNode,
                          );
                        });
                        return;
                      }

                      if (selectedIndex != index) {
                        if (product.Value == 0) {
                          ShowSnackbarMessage.show(
                            message:
                                "O preço está zerado. Por isso não é possível inserir a quantidade!",
                            context: context,
                          );
                          return;
                        }
                        widget.consultedProductController.clear();
                        //necessário apagar o campo da quantidade quando
                        //mudar de produto selecionado

                        FocusScope.of(context).unfocus();
                        setState(() {
                          selectedIndex = index;
                        });

                        Future.delayed(const Duration(milliseconds: 100), () {
                          FocusScope.of(context).requestFocus(
                            transferRequestProvider.consultedProductFocusNode,
                          );
                        });
                      } else {
                        FocusScope.of(context).unfocus();
                        //quando clica no mesmo produto, fecha o teclado
                        setState(() {
                          selectedIndex = -1;
                        });
                      }
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
                  // TitleAndSubtitle.titleAndSubtitle(
                  //   title: "Preço de atacado",
                  //   value: ConvertString.convertToBRL(
                  //     product.WholePracticedPrice,
                  //   ),
                  //   subtitleColor: Colors.black,
                  // ),
                  // TitleAndSubtitle.titleAndSubtitle(
                  //   title: "Qtd mínima p/ atacado",
                  //   value: ConvertString.convertToBrazilianNumber(
                  //     product.MinimumWholeQuantity.toString(),
                  //   ),
                  // ),
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
                    enterpriseOriginCode:
                        arguments["enterpriseOriginCode"].toString(),
                    enterpriseDestinyCode:
                        arguments["enterpriseDestinyCode"].toString(),
                    requestTypeCode: arguments["requestTypeCode"].toString(),
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
                                          arguments["enterpriseOriginCode"]
                                              .toString(),
                                      enterpriseDestinyCode:
                                          arguments["enterpriseDestinyCode"]
                                              .toString(),
                                      requestTypeCode:
                                          arguments["requestTypeCode"]
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
                                          arguments["enterpriseOriginCode"]
                                              .toString(),
                                      enterpriseDestinyCode:
                                          arguments["enterpriseDestinyCode"]
                                              .toString(),
                                      requestTypeCode:
                                          arguments["requestTypeCode"]
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
                      consultedProductController:
                          widget.consultedProductController,
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
                        transferRequestProvider.addProductInCart(
                          consultedProductController:
                              widget.consultedProductController,
                          product: product,
                          enterpriseOriginCode:
                              arguments["enterpriseOriginCode"].toString(),
                          enterpriseDestinyCode:
                              arguments["enterpriseDestinyCode"].toString(),
                          requestTypeCode:
                              arguments["requestTypeCode"].toString(),
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
                            consultedProductController:
                                widget.consultedProductController,
                          );
                        });
                      },
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
