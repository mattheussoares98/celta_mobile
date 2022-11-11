import 'package:celta_inventario/Models/receipt_conference_product_model.dart';
import 'package:celta_inventario/providers/receipt_conference_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                flex: 4,
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
                          await widget.receiptConferenceProvider.anullQuantity(
                            docCode: widget.docCode,
                            productgCode: widget.receiptConferenceProductModel
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
              const SizedBox(width: 5),
              Flexible(
                flex: 7,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // primary: Colors.red,
                    minimumSize: const Size(double.infinity, 50),
                    maximumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: widget
                              .receiptConferenceProvider.isUpdatingQuantity ||
                          widget.receiptConferenceProvider.consultingProducts
                      ? null
                      : () async {
                          if (!isValid()) return;
                          FocusScope.of(context).unfocus();
                          await widget.receiptConferenceProvider.updateQuantity(
                            docCode: widget.docCode,
                            productgCode: widget.receiptConferenceProductModel
                                .CodigoInterno_Produto,
                            productPackingCode: widget
                                .receiptConferenceProductModel
                                .CodigoInterno_ProEmb,
                            quantityText:
                                widget.consultedProductController.text,
                            index: widget.index,
                            context: context,
                          );

                          if (widget.receiptConferenceProvider
                                  .errorMessageUpdateQuantity ==
                              "") {
                            widget.consultedProductController.clear();
                          }
                        },
                  child: FittedBox(
                    child: Text(
                      widget.receiptConferenceProvider.isUpdatingQuantity ||
                              widget
                                  .receiptConferenceProvider.consultingProducts
                          ? "AGUARDE"
                          : "Alterar",
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
      ],
    );
  }
}
