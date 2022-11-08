import 'package:celta_inventario/providers/adjust_stock_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdjustStockInsertQuantity extends StatefulWidget {
  final AdjustStockProvider adjustStockProvider;
  final TextEditingController consultedProductController;
  final GlobalKey<FormState> dropDownFormKey;
  final GlobalKey<FormState> insertQuantityFormKey;
  final int internalEnterpriseCode;
  final int index;

  const AdjustStockInsertQuantity({
    required this.adjustStockProvider,
    required this.internalEnterpriseCode,
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
  @override
  Widget build(BuildContext context) {
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
                        widget.adjustStockProvider.consultedProductFocusNode,
                    enabled: widget.adjustStockProvider.isLoadingProducts ||
                            widget.adjustStockProvider
                                .isLoadingTypeStockAndJustifications ||
                            widget.adjustStockProvider.isLoadingAdjustStock
                        ? false
                        : true,
                    controller: widget.consultedProductController,
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
                        color: widget.adjustStockProvider.isLoadingProducts ||
                                widget.adjustStockProvider
                                    .isLoadingTypeStockAndJustifications ||
                                widget.adjustStockProvider.isLoadingAdjustStock
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
                        color: widget.adjustStockProvider.isLoadingProducts ||
                                widget.adjustStockProvider
                                    .isLoadingTypeStockAndJustifications ||
                                widget.adjustStockProvider.isLoadingAdjustStock
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
                  flex: 5,
                  child: ElevatedButton(
                    onPressed: widget.adjustStockProvider.isLoadingAdjustStock
                        ? null
                        : () async {
                            widget.dropDownFormKey.currentState!.validate();
                            widget.insertQuantityFormKey.currentState!
                                .validate();

                            if (widget.dropDownFormKey.currentState!
                                    .validate() &&
                                widget.insertQuantityFormKey.currentState!
                                    .validate()) {
                              print("formulários corretos. Pode salvar");

                              widget.adjustStockProvider
                                      .jsonAdjustStock["Quantity"] =
                                  widget.consultedProductController.text;

                              widget.adjustStockProvider
                                      .jsonAdjustStock["EnterpriseCode"] =
                                  widget.internalEnterpriseCode.toString();

                              await widget.adjustStockProvider
                                  .confirmAdjustStock(
                                context: context,
                                indexOfProduct: widget.index,
                                consultedProductControllerText:
                                    widget.consultedProductController.text,
                              );

                              if (widget.adjustStockProvider
                                      .errorMessageAdjustStock ==
                                  "") {
                                widget.consultedProductController.clear();
                              }
                            }
                          },
                    child: FittedBox(
                      child: Text(
                        widget.adjustStockProvider.isLoadingAdjustStock
                            ? "Aguarde"
                            : "Confirmar",
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
          if (widget.adjustStockProvider.lastUpdatedQuantity != "" &&
              // widget.adjustStockProvider
              //         .indexOfLastProductChangedStockQuantity !=
              //     -1 &&
              widget.adjustStockProvider
                      .indexOfLastProductChangedStockQuantity ==
                  widget.index)
            FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Última quantidade confirmada: ${widget.adjustStockProvider.lastUpdatedQuantity}",
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
