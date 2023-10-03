import 'package:celta_inventario/Components/Global_widgets/add_subtract_or_anull_widget.dart';
import 'package:celta_inventario/Components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/Models/receipt_models/receipt_products_model.dart';
import 'package:celta_inventario/components/Global_widgets/show_snackbar_message.dart';
import 'package:celta_inventario/providers/configurations_provider.dart';
import 'package:celta_inventario/providers/receipt_provider.dart';
import 'package:celta_inventario/utils/convert_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Global_widgets/show_alert_dialog.dart';

class ReceiptConferenceProductsItems extends StatefulWidget {
  final int docCode;
  final TextEditingController consultedProductController;
  final TextEditingController consultProductController;
  final Function onFieldSubmitted;
  final Function getProductsWithCamera;

  const ReceiptConferenceProductsItems({
    required this.getProductsWithCamera,
    required this.consultedProductController,
    required this.onFieldSubmitted,
    required this.consultProductController,
    required this.docCode,
    Key? key,
  }) : super(key: key);

  @override
  State<ReceiptConferenceProductsItems> createState() =>
      _ReceiptConferenceProductsItemsState();
}

class _ReceiptConferenceProductsItemsState
    extends State<ReceiptConferenceProductsItems> {
  int selectedIndex = -1;

  updateQuantity({
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
        selectedIndex = -1;
      });

      if (configurationsProvider.useAutoScan) {
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

  anullQuantity({
    required int index,
    required ReceiptProvider receiptProvider,
    required ConfigurationsProvider configurationsProvider,
  }) async {
    FocusScope.of(context).unfocus();

    if (receiptProvider.products[index].Quantidade_ProcRecebDocProEmb == null) {
      ShowSnackbarMessage.showMessage(
        message: "A quantidade já está nula!",
        context: context,
      );
      return;
    }

    ShowAlertDialog.showAlertDialog(
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
            selectedIndex = -1;
          });
          widget.consultedProductController.clear();

          if (configurationsProvider.useAutoScan) {
            await widget.getProductsWithCamera();
          }
        }
      },
    );
  }

  changeFocus({
    required ReceiptProvider receiptProvider,
    required int index,
  }) {
    if (selectedIndex == index) {
      if (!receiptProvider.consultedProductFocusNode.hasFocus) {
        FocusScope.of(context).unfocus();
        Future.delayed(const Duration(milliseconds: 100), () {
          //se não colocar em um future pra mudar o foco,
          //não funciona corretamente
          FocusScope.of(context).requestFocus(
            receiptProvider.consultedProductFocusNode,
          );
        });
      } else {
        setState(() {
          selectedIndex = -1;
        });
        FocusScope.of(context).unfocus();
      }
    } else {
      setState(() {
        selectedIndex = index;
      });
      FocusScope.of(context).unfocus();

      Future.delayed(const Duration(milliseconds: 100), () {
        //se não colocar em um future pra mudar o foco,
        //não funciona corretamente
        FocusScope.of(context).requestFocus(
          receiptProvider.consultedProductFocusNode,
        );
      });
    }
  }

  bool isChangedIndex = false;
  @override
  Widget build(BuildContext context) {
    ReceiptProvider receiptProvider = Provider.of(context);
    ConfigurationsProvider configurationsProvider = Provider.of(context);

    return Expanded(
      child: receiptProvider.productsCount <= 0
          ? Container()
          : ListView.builder(
              itemCount: receiptProvider.productsCount,
              itemBuilder: (context, index) {
                ReceiptProductsModel product = receiptProvider.products[index];

                if (!isChangedIndex && receiptProvider.productsCount == 1) {
                  selectedIndex = index;
                  print("sabia");
                  Future.delayed(const Duration(milliseconds: 100), () {
                    //se não colocar em um future pra mudar o foco,
                    //não funciona corretamente
                    FocusScope.of(context).requestFocus(
                      receiptProvider.consultedProductFocusNode,
                    );
                  });

                  isChangedIndex = true;
                }

                return GestureDetector(
                  onTap: receiptProvider.isUpdatingQuantity ||
                          receiptProvider.consultingProducts
                      ? null
                      : () {
                          changeFocus(
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
                            value: product.Nome_Produto,
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "PLU",
                            value: product.CodigoPlu_ProEmb,
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Embalagem",
                            value: product.PackingQuantity,
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Quantidade contada",
                            value: product.Quantidade_ProcRecebDocProEmb == -1
                                ? "nula"
                                : ConvertString.convertToBrazilianNumber(product
                                    .Quantidade_ProcRecebDocProEmb.toString()),
                            subtitleColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Validade",
                            value: product.DataValidade_ProcRecebDocProEmb == ""
                                ? "Nenhuma"
                                : product.DataValidade_ProcRecebDocProEmb
                                        .toString()
                                    .replaceRange(10, null, ""),
                            otherWidget: GestureDetector(
                              onTap: receiptProvider.isUpdatingQuantity ||
                                      receiptProvider.consultingProducts ||
                                      receiptProvider.isLoadingValidityDate
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
                                      );

                                      if (validityDate != null) {
                                        setState(() {
                                          product.DataValidade_ProcRecebDocProEmb =
                                              validityDate.toIso8601String();
                                        });
                                      }
                                    },
                              child: receiptProvider.isLoadingValidityDate
                                  ? Row(
                                      children: [
                                        const Text("Alterando...  "),
                                        Container(
                                          child:
                                              const CircularProgressIndicator(
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
                                                    .isUpdatingQuantity ||
                                                receiptProvider
                                                    .consultingProducts ||
                                                receiptProvider
                                                    .isLoadingValidityDate
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
                            value: product.AllEans != ""
                                ? product.AllEans
                                : "Nenhum",
                            otherWidget: Icon(
                              selectedIndex != index
                                  ? Icons.arrow_drop_down_sharp
                                  : Icons.arrow_drop_up_sharp,
                              color: Theme.of(context).colorScheme.primary,
                              size: 30,
                            ),
                          ),
                          if (selectedIndex == index)
                            //só aparece a quantidade contada se o usuário clicar
                            //no produto para ele não saber quais produtos já
                            //foram contados também só aparece a opção de inserir
                            //a quantidade quando clica no produto
                            Column(
                              children: [
                                const SizedBox(height: 10),
                                AddSubtractOrAnullWidget(
                                  onFieldSubmitted: () async {
                                    await widget.onFieldSubmitted();
                                  },
                                  addButtonText: "SOMAR E CONFIRMAR VALIDADE",
                                  subtractButtonText:
                                      "SUBTRAIR E\nCONFIRMAR\nVALIDADE",
                                  consultedProductController:
                                      widget.consultedProductController,
                                  consultedProductFocusNode:
                                      receiptProvider.consultedProductFocusNode,
                                  isUpdatingQuantity:
                                      receiptProvider.isUpdatingQuantity,
                                  isLoading:
                                      receiptProvider.isUpdatingQuantity ||
                                          receiptProvider.consultingProducts ||
                                          receiptProvider.isLoadingValidityDate,
                                  addQuantityFunction: () async {
                                    await updateQuantity(
                                      isSubtract: false,
                                      index: index,
                                      receiptProvider: receiptProvider,
                                      quantityText: widget
                                          .consultedProductController.text,
                                      validityDate: product
                                          .DataValidade_ProcRecebDocProEmb,
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
                                      quantityText: widget
                                          .consultedProductController.text,
                                      validityDate: product
                                          .DataValidade_ProcRecebDocProEmb,
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
            ),
    );
  }
}
