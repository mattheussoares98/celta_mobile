import 'package:celta_inventario/Components/Global_widgets/add_subtract_or_anull_widget.dart';
import 'package:celta_inventario/Components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/components/Global_widgets/personalized_card.dart';
import 'package:celta_inventario/providers/receipt_conference_provider.dart';
import 'package:celta_inventario/Components/Global_widgets/show_error_message.dart';
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

  final GlobalKey<FormState> consultedProductFormKey = GlobalKey();

  updateQuantity({
    required bool isSubtract,
    required int index,
    required ReceiptConferenceProvider receiptConferenceProvider,
    required String quantityText,
    String? validityDate,
  }) async {
    await receiptConferenceProvider.updateQuantity(
      quantityText: quantityText,
      docCode: widget.docCode,
      productgCode:
          receiptConferenceProvider.products[index].CodigoInterno_Produto,
      productPackingCode:
          receiptConferenceProvider.products[index].CodigoInterno_ProEmb,
      index: index,
      context: context,
      isSubtract: isSubtract,
      validityDate: validityDate,
    );

    if (receiptConferenceProvider.errorMessageUpdateQuantity == "") {
      widget.consultedProductController.clear();
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

  @override
  Widget build(BuildContext context) {
    ReceiptConferenceProvider receiptConferenceProvider = Provider.of(context);
    return Expanded(
      child: Column(
        children: [
          Expanded(
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
                                if (!receiptConferenceProvider
                                        .consultedProductFocusNode.hasFocus &&
                                    selectedIndex == index) {
                                  //só cai aqui quando está exibindo a opção de
                                  //alterar/anular a quantidade de algum produto e ele
                                  //não está com o foco. Ao clicar nele novamnete, ao
                                  //invés de minimizá-lo, só altera o foco novamente
                                  //pra ele

                                  Future.delayed(
                                      const Duration(milliseconds: 100), () {
                                    //se não colocar em um future pra mudar o foco,
                                    //não funciona corretamente
                                    FocusScope.of(context).requestFocus(
                                      receiptConferenceProvider
                                          .consultedProductFocusNode,
                                    );
                                  });
                                  return;
                                }
                                if (selectedIndex != index) {
                                  widget.consultedProductController.clear();
                                  //necessário apagar o campo da quantidade quando
                                  //mudar de produto selecionado
                                  Future.delayed(
                                      const Duration(milliseconds: 100), () {
                                    //se não colocar em um future pra mudar o foco,
                                    //não funciona corretamente
                                    FocusScope.of(context).requestFocus(
                                      receiptConferenceProvider
                                          .consultedProductFocusNode,
                                    );
                                  });

                                  setState(() {
                                    selectedIndex = index;
                                    //isso faz com que apareça os botões de "conferir"
                                    //e "liberar" somente no item selecionado
                                  });
                                } else {
                                  FocusScope.of(context).unfocus();
                                  //quando clica no mesmo produto, fecha o teclado. Se
                                  //não fizer isso, o foco volta para o de consulta de
                                  //produtos
                                  setState(() {
                                    selectedIndex = -1;
                                  });
                                }
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
                                  value: receiptConferenceProvider
                                              .products[index]
                                              .Quantidade_ProcRecebDocProEmb ==
                                          null
                                      //se o valor for nulo, basta convertê-lo
                                      //para String. Se não for nulo, basta
                                      //alterar os pontos por vírgula e
                                      //mostrar no máximo 3 casas decimais
                                      ? "nula"
                                      : double.tryParse(
                                              receiptConferenceProvider
                                                  .products[index]
                                                  .Quantidade_ProcRecebDocProEmb
                                                  .toString())!
                                          .toStringAsFixed(3)
                                          .replaceAll(RegExp(r'\.'), ','),
                                  subtitleColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                                TitleAndSubtitle.titleAndSubtitle(
                                  title: "Validade",
                                  value: receiptConferenceProvider
                                              .products[index]
                                              .DataValidade_ProcRecebDocProEmb ==
                                          ""
                                      ? "Nenhuma"
                                      : receiptConferenceProvider
                                          .products[index]
                                          .DataValidade_ProcRecebDocProEmb
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
                                              await updateQuantity(
                                                isSubtract: false,
                                                index: index,
                                                receiptConferenceProvider:
                                                    receiptConferenceProvider,
                                                quantityText: "0",
                                                validityDate:
                                                    validityDate.toString(),
                                              );
                                            }
                                          },
                                    child:
                                        receiptConferenceProvider
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
                                                  color: receiptConferenceProvider.isUpdatingQuantity ||
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
                                  value: receiptConferenceProvider
                                              .products[index].AllEans !=
                                          ""
                                      ? receiptConferenceProvider
                                          .products[index].AllEans
                                      : "Nenhum",
                                  otherWidget: Icon(
                                    selectedIndex != index
                                        ? Icons.arrow_drop_down_sharp
                                        : Icons.arrow_drop_up_sharp,
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
                                        consultedProductController:
                                            widget.consultedProductController,
                                        consultedProductFormKey:
                                            consultedProductFormKey,
                                        consultedProductFocusNode:
                                            receiptConferenceProvider
                                                .consultedProductFocusNode,
                                        isUpdatingQuantity:
                                            receiptConferenceProvider
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
                                                .consultedProductController
                                                .text,
                                          );
                                        },
                                        subtractQuantityFunction: () async {
                                          await updateQuantity(
                                            isSubtract: true,
                                            index: index,
                                            receiptConferenceProvider:
                                                receiptConferenceProvider,
                                            quantityText: widget
                                                .consultedProductController
                                                .text,
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
          ),
        ],
      ),
    );
  }
}
