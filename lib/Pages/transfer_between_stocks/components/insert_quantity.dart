import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../providers/providers.dart';
import '../../../components/components.dart';

class InsertQuantity extends StatefulWidget {
  final TextEditingController consultedProductController;
  final GlobalKey<FormState> dropDownFormKey;
  final GlobalKey<FormState> insertQuantityFormKey;
  final int internalEnterpriseCode;
  final int index;
  final Function getProductsWithCamera;

  const InsertQuantity({
    required this.internalEnterpriseCode,
    required this.getProductsWithCamera,
    required this.dropDownFormKey,
    required this.insertQuantityFormKey,
    required this.consultedProductController,
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  State<InsertQuantity> createState() =>
      _InsertQuantityState();
}

class _InsertQuantityState
    extends State<InsertQuantity> {
  bool _isValid() {
    widget.dropDownFormKey.currentState!.validate();
    widget.insertQuantityFormKey.currentState!.validate();

    return widget.dropDownFormKey.currentState!.validate() &&
        widget.insertQuantityFormKey.currentState!.validate();
  }

  confirmAdjustStock({
    required TransferBetweenStocksProvider transferBetweenStocksProvider,
    required ConfigurationsProvider configurationsProvider,
  }) async {
    if (widget.consultedProductController.text.contains("\,")) {
      widget.consultedProductController.text =
          widget.consultedProductController.text.replaceAll(RegExp(r'\,'), '.');
    }
    transferBetweenStocksProvider.jsonAdjustStock["Quantity"] =
        double.parse(widget.consultedProductController.text);

    transferBetweenStocksProvider.jsonAdjustStock["EnterpriseCode"] =
        widget.internalEnterpriseCode;

    await transferBetweenStocksProvider.confirmAdjustStock(
      context: context,
      indexOfProduct: widget.index,
      consultedProductControllerText: widget.consultedProductController.text,
    );

    if (transferBetweenStocksProvider.errorMessageAdjustStock == "") {
      widget.consultedProductController.clear();
    }

    if (configurationsProvider.autoScan?.value == true &&
        transferBetweenStocksProvider.errorMessageAdjustStock == "") {
      await widget.getProductsWithCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    TransferBetweenStocksProvider transferBetweenStocksProvider =
        Provider.of(context);
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
                    focusNode:
                        transferBetweenStocksProvider.consultedProductFocusNode,
                    enabled: transferBetweenStocksProvider.isLoadingProducts ||
                            transferBetweenStocksProvider
                                .isLoadingTypeStockAndJustifications ||
                            transferBetweenStocksProvider.isLoadingAdjustStock
                        ? false
                        : true,
                    controller: widget.consultedProductController,
                    inputFormatters: [LengthLimitingTextInputFormatter(10)],
                    onFieldSubmitted: (_) async {
                      if (_isValid()) {
                        ShowAlertDialog.showAlertDialog(
                          context: context,
                          title: "Confirmar transferência",
                          function: () async {
                            await confirmAdjustStock(
                              transferBetweenStocksProvider:
                                  transferBetweenStocksProvider,
                              configurationsProvider: configurationsProvider,
                            );
                          },
                        );
                      }
                    },
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
                      isLoading: transferBetweenStocksProvider
                              .isLoadingProducts ||
                          transferBetweenStocksProvider
                              .isLoadingTypeStockAndJustifications ||
                          transferBetweenStocksProvider.isLoadingAdjustStock,
                      context: context,
                      labelText: "Quantidade",
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
                    onPressed:
                        transferBetweenStocksProvider.isLoadingAdjustStock
                            ? null
                            : () async {
                                if (_isValid()) {
                                  ShowAlertDialog.showAlertDialog(
                                    context: context,
                                    title: "Confirmar transferência",
                                    function: () async {
                                      await confirmAdjustStock(
                                        transferBetweenStocksProvider:
                                            transferBetweenStocksProvider,
                                        configurationsProvider:
                                            configurationsProvider,
                                      );
                                    },
                                  );
                                }
                              },
                    child: transferBetweenStocksProvider.isLoadingAdjustStock
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
        ],
      ),
    );
  }
}
