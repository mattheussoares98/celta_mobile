import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../providers/providers.dart';

class AdjustStockInsertQuantity extends StatefulWidget {
  final TextEditingController consultedProductController;
  final GlobalKey<FormState> dropDownFormKey;
  final GlobalKey<FormState> insertQuantityFormKey;
  final int internalEnterpriseCode;
  final int index;
  final Function getProductWithCamera;
  final Function updateSelectedIndex;

  const AdjustStockInsertQuantity({
    required this.internalEnterpriseCode,
    required this.updateSelectedIndex,
    required this.getProductWithCamera,
    required this.dropDownFormKey,
    required this.insertQuantityFormKey,
    required this.consultedProductController,
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  State<AdjustStockInsertQuantity> createState() =>
      _AdjustStockInsertQuantityState();
}

class _AdjustStockInsertQuantityState extends State<AdjustStockInsertQuantity> {
  bool _isValid() {
    widget.dropDownFormKey.currentState!.validate();
    widget.insertQuantityFormKey.currentState!.validate();

    return widget.dropDownFormKey.currentState!.validate() &&
        widget.insertQuantityFormKey.currentState!.validate();
  }

  confirmAdjustStock({
    required AdjustStockProvider adjustStockProvider,
    required ConfigurationsProvider configurationsProvider,
  }) async {
    if (widget.consultedProductController.text.contains("\,")) {
      widget.consultedProductController.text =
          widget.consultedProductController.text.replaceAll(RegExp(r'\,'), '.');
    }
    adjustStockProvider.jsonAdjustStock["Quantity"] =
        widget.consultedProductController.text;

    adjustStockProvider.jsonAdjustStock["EnterpriseCode"] =
        widget.internalEnterpriseCode.toString();

    await adjustStockProvider.confirmAdjustStock(
      context: context,
      indexOfProduct: widget.index,
      consultedProductControllerText: widget.consultedProductController.text,
    );

    if (adjustStockProvider.errorMessageAdjustStock == "") {
      widget.consultedProductController.clear();
      widget.updateSelectedIndex();

      if (configurationsProvider.autoScan?.value == true) {
        await widget.getProductWithCamera();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AdjustStockProvider adjustStockProvider = Provider.of(context);
    ConfigurationsProvider configurationsProvider = Provider.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Form(
            key: widget.insertQuantityFormKey,
            child: Row(
              children: [
                Flexible(
                  flex: 10,
                  child: TextFormField(
                    focusNode: adjustStockProvider.consultedProductFocusNode,
                    controller: widget.consultedProductController,
                    inputFormatters: [LengthLimitingTextInputFormatter(10)],
                    onChanged: (value) {
                      if (value.isEmpty || value == '-') {
                        value = '0';
                      }
                      if (value.startsWith(",") || value.startsWith(".")) {
                        widget.consultedProductController.text =
                            "0" + widget.consultedProductController.text;
                        widget.consultedProductController.selection =
                            TextSelection.fromPosition(
                          TextPosition(
                            offset:
                                widget.consultedProductController.text.length,
                          ),
                        );
                      }
                    },
                    validator: FormFieldValidations.number,
                    decoration: FormFieldDecoration.decoration(
                      context: context,
                      labelText: 'Quantidade',
                    ),
                    onFieldSubmitted: (_) async {
                      if (_isValid()) {
                        //print("formulários corretos. Pode salvar");
                        ShowAlertDialog.show(
                          context: context,
                          title: "Confirmar ajuste",
                          function: () async {
                            await confirmAdjustStock(
                              adjustStockProvider: adjustStockProvider,
                              configurationsProvider: configurationsProvider,
                            );
                          },
                        );
                      }
                    },
                    style: FormFieldStyle.style(),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: 5),
                Flexible(
                  flex: 9,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 60),
                      maximumSize: const Size(double.infinity, 60),
                    ),
                    onPressed: () async {
                      if (_isValid()) {
                        //print("formulários corretos. Pode salvar");
                        ShowAlertDialog.show(
                          context: context,
                          title: "Confirmar ajuste",
                          function: () async {
                            await confirmAdjustStock(
                              adjustStockProvider: adjustStockProvider,
                              configurationsProvider: configurationsProvider,
                            );
                          },
                        );
                      }
                    },
                    child: const FittedBox(
                      child: Text(
                        "CONFIRMAR",
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
