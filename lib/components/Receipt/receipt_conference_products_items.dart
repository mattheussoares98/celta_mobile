import 'package:celta_inventario/Components/Global_widgets/add_subtract_or_anull_widget.dart';
import 'package:celta_inventario/Components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/components/Global_widgets/personalized_card.dart';
import 'package:celta_inventario/providers/receipt_conference_provider.dart';
import 'package:celta_inventario/Components/Global_widgets/show_error_message.dart';
import 'package:flutter/material.dart';

import '../Global_widgets/show_alert_dialog.dart';

class ReceiptConferenceProductsItems extends StatefulWidget {
  final int docCode;
  final ReceiptConferenceProvider receiptConferenceProvider;
  final TextEditingController consultedProductController;
  final TextEditingController consultProductController;
  const ReceiptConferenceProductsItems({
    required this.consultedProductController,
    required this.consultProductController,
    required this.docCode,
    required this.receiptConferenceProvider,
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
  }) async {
    await widget.receiptConferenceProvider.updateQuantity(
      quantityText: widget.consultedProductController.text,
      docCode: widget.docCode,
      productgCode: widget
          .receiptConferenceProvider.products[index].CodigoInterno_Produto,
      productPackingCode:
          widget.receiptConferenceProvider.products[index].CodigoInterno_ProEmb,
      index: index,
      context: context,
      isSubtract: isSubtract,
    );

    if (widget.receiptConferenceProvider.errorMessageUpdateQuantity == "") {
      widget.consultedProductController.clear();
    }
  }

  anullQuantity(int index) async {
    FocusScope.of(context).unfocus();

    if (widget.receiptConferenceProvider.products[index]
            .Quantidade_ProcRecebDocProEmb ==
        null) {
      ShowErrorMessage.showErrorMessage(
        error: "A quantidade j?? est?? nula!",
        context: context,
      );
      return;
    }

    ShowAlertDialog().showAlertDialog(
      context: context,
      title: "Deseja realmente anular a quantidade?",
      function: () async {
        await widget.receiptConferenceProvider.anullQuantity(
          docCode: widget.docCode,
          productgCode: widget
              .receiptConferenceProvider.products[index].CodigoInterno_Produto,
          productPackingCode: widget
              .receiptConferenceProvider.products[index].CodigoInterno_ProEmb,
          index: index,
          context: context,
        );

        if (widget.receiptConferenceProvider.errorMessageUpdateQuantity == "") {
          widget.consultedProductController.clear();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: widget.receiptConferenceProvider.productsCount <= 0
                ? Container()
                : ListView.builder(
                    itemCount: widget.receiptConferenceProvider.productsCount,
                    itemBuilder: (context, index) {
                      var product =
                          widget.receiptConferenceProvider.products[index];
                      return GestureDetector(
                        onTap: widget.receiptConferenceProvider
                                    .isUpdatingQuantity ||
                                widget.receiptConferenceProvider
                                    .consultingProducts
                            ? null
                            : () {
                                if (!widget.receiptConferenceProvider
                                        .consultedProductFocusNode.hasFocus &&
                                    selectedIndex == index) {
                                  //s?? cai aqui quando est?? exibindo a op????o de
                                  //alterar/anular a quantidade de algum produto e ele
                                  //n??o est?? com o foco. Ao clicar nele novamnete, ao
                                  //inv??s de minimiz??-lo, s?? altera o foco novamente
                                  //pra ele

                                  Future.delayed(
                                      const Duration(milliseconds: 100), () {
                                    //se n??o colocar em um future pra mudar o foco,
                                    //n??o funciona corretamente
                                    FocusScope.of(context).requestFocus(
                                      widget.receiptConferenceProvider
                                          .consultedProductFocusNode,
                                    );
                                  });
                                  return;
                                }
                                if (selectedIndex != index) {
                                  widget.consultedProductController.clear();
                                  //necess??rio apagar o campo da quantidade quando
                                  //mudar de produto selecionado
                                  Future.delayed(
                                      const Duration(milliseconds: 100), () {
                                    //se n??o colocar em um future pra mudar o foco,
                                    //n??o funciona corretamente
                                    FocusScope.of(context).requestFocus(
                                      widget.receiptConferenceProvider
                                          .consultedProductFocusNode,
                                    );
                                  });

                                  setState(() {
                                    selectedIndex = index;
                                    //isso faz com que apare??a os bot??es de "conferir"
                                    //e "liberar" somente no item selecionado
                                  });
                                } else {
                                  FocusScope.of(context).unfocus();
                                  //quando clica no mesmo produto, fecha o teclado. Se
                                  //n??o fizer isso, o foco volta para o de consulta de
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
                                  title: "EANs",
                                  value: widget.receiptConferenceProvider
                                              .products[index].AllEans !=
                                          ""
                                      ? widget.receiptConferenceProvider
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
                                  //s?? aparece a quantidade contada se o usu??rio clicar
                                  //no produto para ele n??o saber quais produtos j??
                                  //foram contados tamb??m s?? aparece a op????o de inserir
                                  //a quantidade quando clica no produto
                                  Column(
                                    children: [
                                      TitleAndSubtitle.titleAndSubtitle(
                                        title: "Quantidade contada",
                                        value: widget
                                                    .receiptConferenceProvider
                                                    .products[index]
                                                    .Quantidade_ProcRecebDocProEmb ==
                                                null
                                            //se o valor for nulo, basta convert??-lo
                                            //para String. Se n??o for nulo, basta
                                            //alterar os pontos por v??rgula e
                                            //mostrar no m??ximo 3 casas decimais
                                            ? "nula"
                                            : double.tryParse(widget
                                                    .receiptConferenceProvider
                                                    .products[index]
                                                    .Quantidade_ProcRecebDocProEmb
                                                    .toString())!
                                                .toStringAsFixed(3)
                                                .replaceAll(RegExp(r'\.'), ','),
                                      ),
                                      const SizedBox(height: 10),
                                      AddSubtractOrAnullWidget(
                                        consultedProductController:
                                            widget.consultedProductController,
                                        consultedProductFormKey:
                                            consultedProductFormKey,
                                        consultedProductFocusNode: widget
                                            .receiptConferenceProvider
                                            .consultedProductFocusNode,
                                        isUpdatingQuantity: widget
                                            .receiptConferenceProvider
                                            .isUpdatingQuantity,
                                        isLoading: widget
                                                .receiptConferenceProvider
                                                .isUpdatingQuantity ||
                                            widget.receiptConferenceProvider
                                                .consultingProducts,
                                        addQuantityFunction: () async {
                                          await updateQuantity(
                                            isSubtract: false,
                                            index: index,
                                          );
                                        },
                                        subtractQuantityFunction: () async {
                                          await updateQuantity(
                                            isSubtract: true,
                                            index: index,
                                          );
                                        },
                                        anullFunction: () async {
                                          await anullQuantity(index);
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
