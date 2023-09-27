import 'package:celta_inventario/components/Global_widgets/show_alert_dialog.dart';
import 'package:celta_inventario/providers/transfer_between_package_provider_SemImplementacaoAinda.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TransferBetweenPackageInsertQuantity extends StatefulWidget {
  final TextEditingController consultedProductController;
  final GlobalKey<FormState> dropDownFormKey;
  final GlobalKey<FormState> insertQuantityFormKey;
  final int internalEnterpriseCode;
  final int index;

  const TransferBetweenPackageInsertQuantity({
    required this.internalEnterpriseCode,
    required this.dropDownFormKey,
    required this.insertQuantityFormKey,
    required this.consultedProductController,
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  State<TransferBetweenPackageInsertQuantity> createState() =>
      _TransferBetweenPackageInsertQuantityState();
}

class _TransferBetweenPackageInsertQuantityState
    extends State<TransferBetweenPackageInsertQuantity> {
  bool _isValid() {
    widget.dropDownFormKey.currentState!.validate();
    widget.insertQuantityFormKey.currentState!.validate();

    return widget.dropDownFormKey.currentState!.validate() &&
        widget.insertQuantityFormKey.currentState!.validate();
  }

  confirmAdjustStock({
    required TransferBetweenPackageProvider transferBetweenPackageProvider,
  }) async {
    if (widget.consultedProductController.text.contains("\,")) {
      widget.consultedProductController.text =
          widget.consultedProductController.text.replaceAll(RegExp(r'\,'), '.');
    }
    transferBetweenPackageProvider.jsonAdjustStock["Quantity"] =
        double.parse(widget.consultedProductController.text);

    transferBetweenPackageProvider.jsonAdjustStock["EnterpriseCode"] =
        widget.internalEnterpriseCode;

    await transferBetweenPackageProvider.confirmAdjustStock(
      context: context,
      indexOfProduct: widget.index,
      consultedProductControllerText: widget.consultedProductController.text,
    );

    if (transferBetweenPackageProvider.errorMessageAdjustStock == "") {
      widget.consultedProductController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    TransferBetweenPackageProvider transferBetweenPackageProvider =
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
                    focusNode: transferBetweenPackageProvider
                        .consultedProductFocusNode,
                    enabled: transferBetweenPackageProvider.isLoadingProducts ||
                            transferBetweenPackageProvider
                                .isLoadingTypeStockAndJustifications ||
                            transferBetweenPackageProvider.isLoadingAdjustStock
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
                      } else if (double.tryParse(value) == 0) {
                        return "Digite uma quantidade";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Digite a quantidade aqui',
                      floatingLabelStyle: TextStyle(
                        color:
                            transferBetweenPackageProvider.isLoadingProducts ||
                                    transferBetweenPackageProvider
                                        .isLoadingTypeStockAndJustifications ||
                                    transferBetweenPackageProvider
                                        .isLoadingAdjustStock
                                ? Colors.grey
                                : Theme.of(context).primaryColor,
                      ),
                      hintStyle: const TextStyle(
                        fontSize: 17,
                        color: Colors.grey,
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
                      enabledBorder: OutlineInputBorder(
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
                        color:
                            transferBetweenPackageProvider.isLoadingProducts ||
                                    transferBetweenPackageProvider
                                        .isLoadingTypeStockAndJustifications ||
                                    transferBetweenPackageProvider
                                        .isLoadingAdjustStock
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
                const SizedBox(width: 5),
                Flexible(
                  flex: 9,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 60),
                      maximumSize: const Size(double.infinity, 60),
                    ),
                    onPressed:
                        transferBetweenPackageProvider.isLoadingAdjustStock
                            ? null
                            : () async {
                                if (_isValid()) {
                                  ShowAlertDialog.showAlertDialog(
                                    context: context,
                                    title: "Confirmar transferência",
                                    function: () async {
                                      await confirmAdjustStock(
                                        transferBetweenPackageProvider:
                                            transferBetweenPackageProvider,
                                      );
                                    },
                                  );
                                }
                              },
                    child: transferBetweenPackageProvider.isLoadingAdjustStock
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
          if (transferBetweenPackageProvider.lastUpdatedQuantity != "" &&
              // transferBetweenPackageProvider
              //         .indexOfLastProductChangedStockQuantity !=
              //     -1 &&
              transferBetweenPackageProvider
                      .indexOfLastProductChangedStockQuantity ==
                  widget.index)
            FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Última quantidade confirmada: ${transferBetweenPackageProvider.lastUpdatedQuantity}",
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
