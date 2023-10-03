import 'package:celta_inventario/Components/Global_widgets/show_alert_dialog.dart';
import 'package:celta_inventario/components/Global_widgets/formfield_decoration.dart';
import 'package:celta_inventario/providers/adjust_stock_provider.dart';
import 'package:celta_inventario/providers/configurations_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AdjustStockInsertQuantity extends StatefulWidget {
  final TextEditingController consultedProductController;
  final GlobalKey<FormState> dropDownFormKey;
  final GlobalKey<FormState> insertQuantityFormKey;
  final int internalEnterpriseCode;
  final int index;
  final Function getProductWithCamera;

  const AdjustStockInsertQuantity({
    required this.internalEnterpriseCode,
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

      if (configurationsProvider.useAutoScan) {
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
                    // autofocus: true,
                    focusNode: adjustStockProvider.consultedProductFocusNode,
                    enabled: adjustStockProvider.isLoadingProducts ||
                            adjustStockProvider
                                .isLoadingTypeStockAndJustifications ||
                            adjustStockProvider.isLoadingAdjustStock
                        ? false
                        : true,
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
                    validator: FormFieldHelper.validatorOfNumber(),
                    decoration: FormFieldHelper.decoration(
                      isLoading: adjustStockProvider.isLoadingProducts ||
                          adjustStockProvider
                              .isLoadingTypeStockAndJustifications ||
                          adjustStockProvider.isLoadingAdjustStock,
                      context: context,
                      labelText: 'Quantidade',
                    ),
                    style: FormFieldHelper.style(),
                    keyboardType: TextInputType.number,
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
                    onPressed: adjustStockProvider.isLoadingAdjustStock
                        ? null
                        : () async {
                            if (_isValid()) {
                              print("formulários corretos. Pode salvar");
                              ShowAlertDialog.showAlertDialog(
                                context: context,
                                title: "Confirmar ajuste",
                                function: () async {
                                  await confirmAdjustStock(
                                    adjustStockProvider: adjustStockProvider,
                                    configurationsProvider:
                                        configurationsProvider,
                                  );
                                },
                              );
                            }
                          },
                    child: adjustStockProvider.isLoadingAdjustStock
                        ? FittedBox(
                            child: Row(
                              children: [
                                const Text(
                                  "AGUARDE",
                                  style: const TextStyle(
                                    fontSize: 50,
                                  ),
                                ),
                                const SizedBox(width: 30),
                                Container(
                                  width: 60,
                                  height: 60,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 10,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const FittedBox(
                            child: Text(
                              "CONFIRMAR",
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
          if (adjustStockProvider.lastUpdatedQuantity != "" &&
              // adjustStockProvider
              //         .indexOfLastProductChangedStockQuantity !=
              //     -1 &&
              adjustStockProvider.indexOfLastProductChangedStockQuantity ==
                  widget.index)
            FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Última quantidade confirmada: ${adjustStockProvider.lastUpdatedQuantity}",
                  style: TextStyle(
                    fontSize: 100,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'BebasNeue',
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1,
                    wordSpacing: 4,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
