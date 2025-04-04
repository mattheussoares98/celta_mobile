import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Models/receipt/receipt.dart';
import '../../../../providers/providers.dart';
import '../../../../utils/utils.dart';
import '../../../../components/components.dart';

class ConferenceProductsItems extends StatefulWidget {
  final int docCode;
  final TextEditingController consultedProductController;
  final TextEditingController consultProductController;
  final Function getProductsWithCamera;

  const ConferenceProductsItems({
    required this.getProductsWithCamera,
    required this.consultedProductController,
    required this.consultProductController,
    required this.docCode,
    Key? key,
  }) : super(key: key);

  @override
  State<ConferenceProductsItems> createState() =>
      _ConferenceProductsItemsState();
}

class _ConferenceProductsItemsState extends State<ConferenceProductsItems> {
  int _selectedIndex = -1;

  Future<void> updateQuantity({
    required bool isSubtract,
    required int index,
    required ReceiptProvider receiptProvider,
    required String quantityText,
    required String validityDate,
    required ReceiptProductsModel product,
    required ConfigurationsProvider configurationsProvider,
  }) async {
    await receiptProvider.updateQuantity(
      quantityText: quantityText,
      docCode: widget.docCode,
      productgCode: product.CodigoInterno_Produto,
      productPackingCode: product.CodigoInterno_ProEmb,
      index: index,
      context: context,
      isSubtract: isSubtract,
      validityDate: validityDate,
    );

    if (receiptProvider.errorMessageUpdateQuantity == "") {
      widget.consultedProductController.clear();
      setState(() {
        _selectedIndex = -1;
      });

      if (configurationsProvider.autoScan?.value == true &&
          !Platform.isWindows) {
        await widget.getProductsWithCamera();
      }

      Future.delayed(const Duration(milliseconds: 100), () {
        //se não colocar em um future pra mudar o foco,
        //não funciona corretamente
        FocusScope.of(context).requestFocus(
          receiptProvider.consultProductFocusNode,
        );
      });
    }
  }

  Future<void> anullQuantity({
    required int index,
    required ReceiptProvider receiptProvider,
    required ConfigurationsProvider configurationsProvider,
  }) async {
    FocusScope.of(context).unfocus();

    if (receiptProvider.products[index].Quantidade_ProcRecebDocProEmb == null) {
      ShowSnackbarMessage.show(
        message: "A quantidade já está nula!",
        context: context,
      );
      return;
    }

    ShowAlertDialog.show(
      context: context,
      title: "Deseja realmente anular a quantidade?",
      function: () async {
        await receiptProvider.anullQuantity(
          docCode: widget.docCode,
          productgCode: receiptProvider.products[index].CodigoInterno_Produto,
          productPackingCode:
              receiptProvider.products[index].CodigoInterno_ProEmb,
          index: index,
          context: context,
        );

        if (receiptProvider.errorMessageUpdateQuantity == "") {
          setState(() {
            _selectedIndex = -1;
          });
          widget.consultedProductController.clear();

          if (configurationsProvider.autoScan?.value == true) {
            await widget.getProductsWithCamera();
          }
        }
      },
    );
  }

  void changeFocusToConsultedProductFocusNode({
    required ReceiptProvider receiptProvider,
  }) {
    Future.delayed(const Duration(milliseconds: 300), () {
      //se não colocar em um future pra mudar o foco,
      //não funciona corretamente
      FocusScope.of(context).requestFocus(
        receiptProvider.consultedProductFocusNode,
      );
    });
  }

  void selectIndexAndFocus({
    required ReceiptProvider receiptProvider,
    required int index,
  }) {
    widget.consultedProductController.text = "";

    if (receiptProvider.isLoadingProducts ||
        receiptProvider.isLoadingUpdateQuantity) {
      return;
    }

    if (kIsWeb) {
      if (_selectedIndex != index) {
        setState(() {
          _selectedIndex = index;
          changeFocusToConsultedProductFocusNode(
            receiptProvider: receiptProvider,
          );
        });
      } else {
        setState(() {
          _selectedIndex = -1;
        });
      }
      return;
    }

    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      if (receiptProvider.consultedProductFocusNode.hasFocus &&
          MediaQuery.of(context).viewInsets.bottom == 0) {
        FocusScope.of(context).unfocus();
        changeFocusToConsultedProductFocusNode(
          receiptProvider: receiptProvider,
        );
      }
      if (!receiptProvider.consultedProductFocusNode.hasFocus) {
        changeFocusToConsultedProductFocusNode(
          receiptProvider: receiptProvider,
        );
      }
      return;
    }

    if (_selectedIndex == index) {
      if (!receiptProvider.consultedProductFocusNode.hasFocus) {
        changeFocusToConsultedProductFocusNode(
          receiptProvider: receiptProvider,
        );
      } else {
        setState(() {
          _selectedIndex = -1;
        });
      }
    }
  }

  bool isChangedIndex = false;
  @override
  Widget build(BuildContext context) {
    ReceiptProvider receiptProvider = Provider.of(context);
    ConfigurationsProvider configurationsProvider = Provider.of(context);

    return receiptProvider.productsCount <= 0
        ? Container()
        : ListView.builder(
            itemCount: receiptProvider.productsCount,
            itemBuilder: (context, index) {
              if (!isChangedIndex && receiptProvider.productsCount == 1) {
                _selectedIndex = index;
                Future.delayed(const Duration(milliseconds: 100), () {
                  //se não colocar em um future pra mudar o foco,
                  //não funciona corretamente
                  FocusScope.of(context).requestFocus(
                    receiptProvider.consultedProductFocusNode,
                  );
                });

                isChangedIndex = true;
              }

              final product = receiptProvider.products[index];

              return GestureDetector(
                onTap: receiptProvider.isLoadingUpdateQuantity ||
                        receiptProvider.isLoadingProducts
                    ? null
                    : () {
                        selectIndexAndFocus(
                          receiptProvider: receiptProvider,
                          index: index,
                        );
                      },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TitleAndSubtitle.titleAndSubtitle(
                          title: "Nome",
                          subtitle: product.Nome_Produto,
                        ),
                        TitleAndSubtitle.titleAndSubtitle(
                          title: "PLU",
                          subtitle: product.CodigoPlu_ProEmb,
                        ),
                        TitleAndSubtitle.titleAndSubtitle(
                          title: "Embalagem",
                          subtitle: product.PackingQuantity,
                        ),
                        TitleAndSubtitle.titleAndSubtitle(
                          title: "Quantidade contada",
                          subtitle: product.Quantidade_ProcRecebDocProEmb == -1
                              ? "nula"
                              : ConvertString.convertToBrazilianNumber(product
                                  .Quantidade_ProcRecebDocProEmb.toString()),
                          subtitleColor: Theme.of(context).colorScheme.primary,
                        ),
                        TitleAndSubtitle.titleAndSubtitle(
                          title: "Validade",
                          subtitle:
                              product.DataValidade_ProcRecebDocProEmb == ""
                                  ? "Nenhuma"
                                  : product.DataValidade_ProcRecebDocProEmb
                                          .toString()
                                      .replaceRange(10, null, ""),
                          otherWidget: GestureDetector(
                            onTap: receiptProvider.isLoadingUpdateQuantity ||
                                    receiptProvider.isLoadingProducts
                                ? null
                                : () async {
                                    DateTime? validityDate =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(
                                        const Duration(days: 3650),
                                      ),
                                      locale: const Locale('pt', 'BR'),
                                    );

                                    if (validityDate != null) {
                                      setState(() {
                                        product.DataValidade_ProcRecebDocProEmb =
                                            validityDate.toIso8601String();
                                      });
                                    }
                                  },
                            child: receiptProvider.isLoadingUpdateQuantity
                                ? Row(
                                    children: [
                                      const Text("Alterando...  "),
                                      Container(
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.grey,
                                        ),
                                        height: 17,
                                        width: 17,
                                      ),
                                    ],
                                  )
                                : Text(
                                    "Alterar validade",
                                    style: TextStyle(
                                      color: receiptProvider
                                                  .isLoadingUpdateQuantity ||
                                              receiptProvider.isLoadingProducts
                                          ? Colors.black
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        TitleAndSubtitle.titleAndSubtitle(
                          title: "EANs",
                          subtitle: product.AllEans != ""
                              ? product.AllEans
                              : "Nenhum",
                          otherWidget: Icon(
                            _selectedIndex != index
                                ? Icons.arrow_drop_down_sharp
                                : Icons.arrow_drop_up_sharp,
                            color: Theme.of(context).colorScheme.primary,
                            size: 30,
                          ),
                        ),
                        if (_selectedIndex == index)
                          //só aparece a quantidade contada se o usuário clicar
                          //no produto para ele não saber quais produtos já
                          //foram contados também só aparece a opção de inserir
                          //a quantidade quando clica no produto
                          Column(
                            children: [
                              const SizedBox(height: 10),
                              AddSubtractOrAnullWidget(
                                onFieldSubmitted: () async {
                                  await updateQuantity(
                                    isSubtract: false,
                                    index: index,
                                    receiptProvider: receiptProvider,
                                    quantityText:
                                        widget.consultedProductController.text,
                                    validityDate:
                                        product.DataValidade_ProcRecebDocProEmb,
                                    product: product,
                                    configurationsProvider:
                                        configurationsProvider,
                                  );
                                },
                                addButtonText: "SOMAR E CONFIRMAR VALIDADE",
                                subtractButtonText:
                                    "SUBTRAIR E\nCONFIRMAR\nVALIDADE",
                                consultedProductController:
                                    widget.consultedProductController,
                                consultedProductFocusNode:
                                    receiptProvider.consultedProductFocusNode,
                                isUpdatingQuantity:
                                    receiptProvider.isLoadingUpdateQuantity,
                                addQuantityFunction: () async {
                                  await updateQuantity(
                                    isSubtract: false,
                                    index: index,
                                    receiptProvider: receiptProvider,
                                    quantityText:
                                        widget.consultedProductController.text,
                                    validityDate:
                                        product.DataValidade_ProcRecebDocProEmb,
                                    product: product,
                                    configurationsProvider:
                                        configurationsProvider,
                                  );
                                },
                                subtractQuantityFunction: () async {
                                  await updateQuantity(
                                    configurationsProvider:
                                        configurationsProvider,
                                    isSubtract: true,
                                    index: index,
                                    receiptProvider: receiptProvider,
                                    quantityText:
                                        widget.consultedProductController.text,
                                    validityDate:
                                        product.DataValidade_ProcRecebDocProEmb,
                                    product: product,
                                  );
                                },
                                anullFunction: () async {
                                  await anullQuantity(
                                    index: index,
                                    receiptProvider: receiptProvider,
                                    configurationsProvider:
                                        configurationsProvider,
                                  );
                                },
                              ),
                            ],
                          ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
