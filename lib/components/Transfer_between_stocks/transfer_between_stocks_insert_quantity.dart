import 'package:celta_inventario/components/Global_widgets/formfield_decoration.dart';
import 'package:celta_inventario/components/Global_widgets/show_alert_dialog.dart';
import 'package:celta_inventario/providers/transfer_between_stocks_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TransferBetweenStocksInsertQuantity extends StatefulWidget {
  final TextEditingController consultedProductController;
  final GlobalKey<FormState> dropDownFormKey;
  final GlobalKey<FormState> insertQuantityFormKey;
  final int internalEnterpriseCode;
  final int index;
  final Function getProductsWithCamera;

  const TransferBetweenStocksInsertQuantity({
    required this.internalEnterpriseCode,
    required this.getProductsWithCamera,
    required this.dropDownFormKey,
    required this.insertQuantityFormKey,
    required this.consultedProductController,
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  State<TransferBetweenStocksInsertQuantity> createState() =>
      _TransferBetweenStocksInsertQuantityState();
}

class _TransferBetweenStocksInsertQuantityState
    extends State<TransferBetweenStocksInsertQuantity> {
  bool _isValid() {
    widget.dropDownFormKey.currentState!.validate();
    widget.insertQuantityFormKey.currentState!.validate();

    return widget.dropDownFormKey.currentState!.validate() &&
        widget.insertQuantityFormKey.currentState!.validate();
  }

  confirmAdjustStock({
    required TransferBetweenStocksProvider transferBetweenStocksProvider,
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

    if (transferBetweenStocksProvider.useAutoScan &&
        transferBetweenStocksProvider.errorMessageAdjustStock == "") {
      await widget.getProductsWithCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    TransferBetweenStocksProvider transferBetweenStocksProvider =
        Provider.of(context);
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
                      labelText: "Digite a quantidade",
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
          if (transferBetweenStocksProvider.lastUpdatedQuantity != "" &&
              // transferBetweenStocksProvider
              //         .indexOfLastProductChangedStockQuantity !=
              //     -1 &&
              transferBetweenStocksProvider
                      .indexOfLastProductChangedStockQuantity ==
                  widget.index)
            FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Última quantidade confirmada: ${transferBetweenStocksProvider.lastUpdatedQuantity}",
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
