import 'package:celta_inventario/Components/Global_widgets/add_subtract_or_anull_widget.dart';
import 'package:celta_inventario/Components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/Models/receipt_conference_product_model.dart';
import 'package:celta_inventario/components/Global_widgets/personalized_card.dart';
import 'package:celta_inventario/providers/receipt_conference_provider.dart';
import 'package:celta_inventario/Components/Global_widgets/show_error_message.dart';
import 'package:celta_inventario/utils/convert_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Global_widgets/show_alert_dialog.dart';

class ReceiptConferenceProductsItems extends StatefulWidget {
  final int docCode;
  final TextEditingController consultedProductController;
  final TextEditingController consultProductController;
  const ReceiptConferenceProductsItems({
    required this.consultedProductController,
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
    required ReceiptConferenceProvider receiptConferenceProvider,
    required String quantityText,
    required String validityDate,
    required ReceiptConferenceProductModel product,
  }) async {
    await receiptConferenceProvider.updateQuantity(
      quantityText: quantityText,
      docCode: widget.docCode,
      productgCode: product.CodigoInterno_Produto,
      productPackingCode: product.CodigoInterno_ProEmb,
      index: index,
      context: context,
      isSubtract: isSubtract,
      validityDate: validityDate,
    );

    if (receiptConferenceProvider.errorMessageUpdateQuantity == "") {
      widget.consultedProductController.clear();
      setState(() {
        selectedIndex = -1;
      });

      Future.delayed(const Duration(milliseconds: 100), () {
        //se não colocar em um future pra mudar o foco,
        //não funciona corretamente
        FocusScope.of(context).requestFocus(
          receiptConferenceProvider.consultProductFocusNode,
        );
      });
    }
  }

  anullQuantity({
    required int index,
    required ReceiptConferenceProvider receiptConferenceProvider,
  }) async {
    FocusScope.of(context).unfocus();

    if (receiptConferenceProvider
            .products[index].Quantidade_ProcRecebDocProEmb ==
        null) {
      ShowErrorMessage.showErrorMessage(
        error: "A quantidade já está nula!",
        context: context,
      );
      return;
    }

    ShowAlertDialog().showAlertDialog(
      context: context,
      title: "Deseja realmente anular a quantidade?",
      function: () async {
        await receiptConferenceProvider.anullQuantity(
          docCode: widget.docCode,
          productgCode:
              receiptConferenceProvider.products[index].CodigoInterno_Produto,
          productPackingCode:
              receiptConferenceProvider.products[index].CodigoInterno_ProEmb,
          index: index,
          context: context,
        );

        if (receiptConferenceProvider.errorMessageUpdateQuantity == "") {
          widget.consultedProductController.clear();
        }
      },
    );
  }

  changeFocus({
    required ReceiptConferenceProvider receiptConferenceProvider,
    required int index,
  }) {
    if (selectedIndex == index) {
      if (!receiptConferenceProvider.consultedProductFocusNode.hasFocus) {
        FocusScope.of(context).unfocus();
        Future.delayed(const Duration(milliseconds: 100), () {
          //se não colocar em um future pra mudar o foco,
          //não funciona corretamente
          FocusScope.of(context).requestFocus(
            receiptConferenceProvider.consultedProductFocusNode,
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
          receiptConferenceProvider.consultedProductFocusNode,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ReceiptConferenceProvider receiptConferenceProvider = Provider.of(context);
    return Expanded(
      child: receiptConferenceProvider.productsCount <= 0
          ? Container()
          : ListView.builder(
              itemCount: receiptConferenceProvider.productsCount,
              itemBuilder: (context, index) {
                var product = receiptConferenceProvider.products[index];
                return GestureDetector(
                  onTap: receiptConferenceProvider.isUpdatingQuantity ||
                          receiptConferenceProvider.consultingProducts
                      ? null
                      : () {
                          changeFocus(
                            receiptConferenceProvider:
                                receiptConferenceProvider,
                            index: index,
                          );
                        },
                  child: PersonalizedCard.personalizedCard(
                    context: context,
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
                            value: product.Quantidade_ProcRecebDocProEmb == null
                                //se o valor for nulo, basta convertê-lo
                                //para String. Se não for nulo, basta
                                //alterar os pontos por vírgula e
                                //mostrar no máximo 3 casas decimais
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
                              onTap: receiptConferenceProvider
                                          .isUpdatingQuantity ||
                                      receiptConferenceProvider
                                          .consultingProducts ||
                                      receiptConferenceProvider
                                          .isLoadingValidityDate
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
                                              validityDate.toString();
                                        });
                                      }
                                    },
                              child: receiptConferenceProvider
                                      .isLoadingValidityDate
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
                                        color: receiptConferenceProvider
                                                    .isUpdatingQuantity ||
                                                receiptConferenceProvider
                                                    .consultingProducts ||
                                                receiptConferenceProvider
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
                                  addButtonText: "SOMAR E CONFIRMAR VALIDADE",
                                  subtractButtonText:
                                      "SUBTRAIR E\nCONFIRMAR\nVALIDADE",
                                  consultedProductController:
                                      widget.consultedProductController,
                                  consultedProductFocusNode:
                                      receiptConferenceProvider
                                          .consultedProductFocusNode,
                                  isUpdatingQuantity: receiptConferenceProvider
                                      .isUpdatingQuantity,
                                  isLoading: receiptConferenceProvider
                                          .isUpdatingQuantity ||
                                      receiptConferenceProvider
                                          .consultingProducts ||
                                      receiptConferenceProvider
                                          .isLoadingValidityDate,
                                  addQuantityFunction: () async {
                                    await updateQuantity(
                                      isSubtract: false,
                                      index: index,
                                      receiptConferenceProvider:
                                          receiptConferenceProvider,
                                      quantityText: widget
                                          .consultedProductController.text,
                                      validityDate: product
                                          .DataValidade_ProcRecebDocProEmb,
                                      product: product,
                                    );
                                  },
                                  subtractQuantityFunction: () async {
                                    await updateQuantity(
                                      isSubtract: true,
                                      index: index,
                                      receiptConferenceProvider:
                                          receiptConferenceProvider,
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
                                      receiptConferenceProvider:
                                          receiptConferenceProvider,
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
