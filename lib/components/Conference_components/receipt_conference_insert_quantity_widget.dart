import 'package:celta_inventario/Models/receipt_conference_product_model.dart';
import 'package:celta_inventario/providers/receipt_conference_provider.dart';
import 'package:celta_inventario/utils/show_alert_dialog.dart';
import 'package:celta_inventario/utils/show_error_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Buttons/addOrSubtractButton.dart';

class ReceiptConferenceInsertQuantityWidget extends StatefulWidget {
  final ReceiptConferenceProvider receiptConferenceProvider;
  final ReceiptConferenceProductModel receiptConferenceProductModel;
  final int docCode;
  final int index;
  final TextEditingController consultedProductController;
  final GlobalKey<FormState> insertQuantityFormKey;
  const ReceiptConferenceInsertQuantityWidget({
    required this.consultedProductController,
    required this.insertQuantityFormKey,
    required this.docCode,
    required this.receiptConferenceProvider,
    required this.receiptConferenceProductModel,
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  State<ReceiptConferenceInsertQuantityWidget> createState() =>
      _ReceiptConferenceInsertQuantityWidget();
}

class _ReceiptConferenceInsertQuantityWidget
    extends State<ReceiptConferenceInsertQuantityWidget> {
  bool isValid() {
    return widget.insertQuantityFormKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Form(
          key: widget.insertQuantityFormKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 10,
                child: Container(
                  child: TextFormField(
                    // autofocus: true,
                    enabled: widget
                                .receiptConferenceProvider.isUpdatingQuantity ||
                            widget.receiptConferenceProvider.consultingProducts
                        ? false
                        : true,
                    controller: widget.consultedProductController,
                    focusNode: widget
                        .receiptConferenceProvider.consultedProductFocusNode,
                    inputFormatters: [LengthLimitingTextInputFormatter(10)],
                    onChanged: (value) {
                      if (value.isEmpty || value == '-') {
                        value = '0';
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Digite uma quantidade';
                      } else if (value == '0' ||
                          value == '0.' ||
                          value == '0,') {
                        return 'Digite uma quantidade';
                      } else if (value.contains('.') && value.contains(',')) {
                        return 'Carácter inválido';
                      } else if (value.contains('-')) {
                        return 'Carácter inválido';
                      } else if (value.contains(' ')) {
                        return 'Carácter inválido';
                      } else if (value.characters.toList().fold<int>(
                              0, (t, e) => e == "." ? t + e.length : t + 0) >
                          1) {
                        //verifica se tem mais de um ponto
                        return 'Carácter inválido';
                      } else if (value.characters.toList().fold<int>(
                              0, (t, e) => e == "," ? t + e.length : t + 0) >
                          1) {
                        //verifica se tem mais de uma vírgula
                        return 'Carácter inválido';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Digite a quantidade aqui',
                      floatingLabelStyle: TextStyle(
                        color: widget.receiptConferenceProvider
                                    .consultingProducts ||
                                widget.receiptConferenceProvider
                                    .isUpdatingQuantity
                            ? Colors.grey
                            : Theme.of(context).primaryColor,
                      ),
                      errorStyle: const TextStyle(
                        fontSize: 17,
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          style: BorderStyle.solid,
                          width: 2,
                          color: Colors.grey,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          style: BorderStyle.solid,
                          width: 2,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      labelStyle: TextStyle(
                        color: widget.receiptConferenceProvider
                                    .consultingProducts ||
                                widget.receiptConferenceProvider
                                    .isUpdatingQuantity
                            ? Colors.grey
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Flexible(
                flex: 3,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    minimumSize: const Size(double.infinity, 50),
                    maximumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: widget
                              .receiptConferenceProvider.isUpdatingQuantity ||
                          widget.receiptConferenceProvider.consultingProducts
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();

                          if (widget
                                  .receiptConferenceProvider
                                  .products[widget.index]
                                  .Quantidade_ProcRecebDocProEmb ==
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
                              await widget.receiptConferenceProvider
                                  .anullQuantity(
                                docCode: widget.docCode,
                                productgCode: widget
                                    .receiptConferenceProductModel
                                    .CodigoInterno_Produto,
                                productPackingCode: widget
                                    .receiptConferenceProductModel
                                    .CodigoInterno_ProEmb,
                                index: widget.index,
                                context: context,
                              );

                              if (widget.receiptConferenceProvider
                                      .errorMessageUpdateQuantity ==
                                  "") {
                                widget.consultedProductController.clear();
                              }
                            },
                          );
                        },
                  child: FittedBox(
                    child: Text(
                      widget.receiptConferenceProvider.isUpdatingQuantity ||
                              widget
                                  .receiptConferenceProvider.consultingProducts
                          ? "AGUARDE"
                          : "ANULAR",
                      style: const TextStyle(
                        fontSize: 50,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Flexible(
                flex: 4,
                child: AddOrSubtractButton(
                  isLoading:
                      widget.receiptConferenceProvider.isUpdatingQuantity,
                  function: () async {
                    await widget.receiptConferenceProvider.updateQuantity(
                      quantityText: widget.consultedProductController.text,
                      docCode: widget.docCode,
                      productgCode: widget
                          .receiptConferenceProductModel.CodigoInterno_Produto,
                      productPackingCode: widget
                          .receiptConferenceProductModel.CodigoInterno_ProEmb,
                      index: widget.index,
                      context: context,
                      isSubtract: true,
                    );

                    if (widget.receiptConferenceProvider
                            .errorMessageUpdateQuantity ==
                        "") {
                      widget.consultedProductController.clear();
                    }
                  },
                  isSubtract: true,
                  formKey: widget.insertQuantityFormKey,
                  isIndividual: false,
                  consultedProductFocusNode: widget
                      .receiptConferenceProvider.consultedProductFocusNode,
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                flex: 10,
                child: AddOrSubtractButton(
                  isLoading:
                      widget.receiptConferenceProvider.isUpdatingQuantity,
                  function: () async {
                    await widget.receiptConferenceProvider.updateQuantity(
                      quantityText: widget.consultedProductController.text,
                      docCode: widget.docCode,
                      productgCode: widget
                          .receiptConferenceProductModel.CodigoInterno_Produto,
                      productPackingCode: widget
                          .receiptConferenceProductModel.CodigoInterno_ProEmb,
                      index: widget.index,
                      context: context,
                      isSubtract: false,
                    );

                    if (widget.receiptConferenceProvider
                            .errorMessageUpdateQuantity ==
                        "") {
                      widget.consultedProductController.clear();
                    }
                  },
                  isSubtract: false,
                  formKey: widget.insertQuantityFormKey,
                  isIndividual: false,
                  consultedProductFocusNode: widget
                      .receiptConferenceProvider.consultedProductFocusNode,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
