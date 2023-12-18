import 'package:celta_inventario/providers/adjust_stock_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdjustStockJustificationsStockDropwdownWidget extends StatefulWidget {
  final GlobalKey<FormState> dropDownFormKey;

  const AdjustStockJustificationsStockDropwdownWidget({
    required this.dropDownFormKey,
    Key? key,
  }) : super(key: key);

  @override
  State<AdjustStockJustificationsStockDropwdownWidget> createState() =>
      _AdjustStockJustificationsStockDropwdownWidgetState();
}

class _AdjustStockJustificationsStockDropwdownWidgetState
    extends State<AdjustStockJustificationsStockDropwdownWidget> {
  final GlobalKey<FormFieldState> _keyJustifications = GlobalKey();
  final GlobalKey<FormFieldState> _keyOriginStockType = GlobalKey();

  bool _changedJustifications = false;
  bool _changedOriginStockType = false;

  @override
  Widget build(BuildContext context) {
    AdjustStockProvider adjustStockProvider = Provider.of(context);

    if (adjustStockProvider.isLoadingTypeStockAndJustifications) {
      if (_changedJustifications) {
        _keyJustifications.currentState?.reset();
        _changedJustifications = false;
      }
      if (_changedOriginStockType) {
        _keyOriginStockType.currentState?.reset();
        _changedOriginStockType = false;
      }
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: widget.dropDownFormKey,
        child: Column(
          children: [
            DropdownButtonFormField<dynamic>(
              // isDense: false,
              key: _keyJustifications,
              disabledHint:
                  adjustStockProvider.isLoadingTypeStockAndJustifications
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FittedBox(
                              child: Text(
                                "Consultando",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 60,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Container(
                              height: 15,
                              width: 15,
                              child: const CircularProgressIndicator(),
                            ),
                          ],
                        )
                      : const Center(child: Text("Justificativas")),
              isExpanded: true,
              hint: Center(
                child: Text(
                  'Justificativas',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              validator: (value) {
                if (value == null) {
                  return 'Selecione uma justificativa!';
                }
                return null;
              },
              onChanged:
                  adjustStockProvider.isLoadingTypeStockAndJustifications ||
                          adjustStockProvider.isLoadingAdjustStock ||
                          adjustStockProvider.isLoadingProducts ||
                          adjustStockProvider.products.isEmpty
                      ? null
                      : (value) {
                          _changedJustifications = true;
                        },
              items: adjustStockProvider.justifications
                  .map(
                    (value) => DropdownMenuItem(
                      alignment: Alignment.center,
                      onTap: () {
                        adjustStockProvider
                                .jsonAdjustStock["JustificationCode"] =
                            value.CodigoInterno_JustMov;

                        if (value.CodigoInterno_TipoEstoque
                                .CodigoInterno_TipoEstoque !=
                            -1) {
                          adjustStockProvider.jsonAdjustStock["StockTypeCode"] =
                              value.CodigoInterno_TipoEstoque
                                  .CodigoInterno_TipoEstoque;
                          adjustStockProvider.justificationHasStockType = true;

                          setState(() {
                            adjustStockProvider
                                .updateJustificationStockTypeName(
                              value.CodigoInterno_TipoEstoque.Nome_TipoEstoque,
                            );
                          });
                        } else {
                          adjustStockProvider.justificationHasStockType = false;
                        }

                        adjustStockProvider.typeOperator = value
                            .TypeOperator; //usado pra aplicação saber se precisa somar ou subtrair o valor do estoque atual
                      },
                      value: value.Descricao_JustMov,
                      child: FittedBox(
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                value.Descricao_JustMov,
                              ),
                            ),
                            const Divider(
                              height: 4,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<dynamic>(
              // isDense: false,
              key: _keyOriginStockType,
              disabledHint:
                  adjustStockProvider.isLoadingTypeStockAndJustifications
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FittedBox(
                              child: Text(
                                "Consultando",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 60,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Container(
                              height: 15,
                              width: 15,
                              child: const CircularProgressIndicator(),
                            ),
                          ],
                        )
                      : Center(
                          child: Text(
                            adjustStockProvider.justificationHasStockType
                                ? adjustStockProvider.justificationStockTypeName
                                : "Estoque de destino",
                          ),
                        ),
              isExpanded: true,
              hint: Center(
                child: Text(
                  'Estoque de destino',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              validator: (value) {
                if (adjustStockProvider.justificationHasStockType) {
                  return null;
                } else if (value == null) {
                  return 'Selecione um tipo de estoque!';
                }
                return null;
              },
              onChanged:
                  adjustStockProvider.isLoadingTypeStockAndJustifications ||
                          adjustStockProvider.isLoadingAdjustStock ||
                          adjustStockProvider.isLoadingProducts ||
                          adjustStockProvider.justificationHasStockType ||
                          adjustStockProvider.products.isEmpty
                      ? null
                      : (value) {
                          _changedOriginStockType = true;
                        },
              items: adjustStockProvider.stockTypes
                  .map(
                    (value) => DropdownMenuItem(
                      alignment: Alignment.center,
                      onTap: () {
                        adjustStockProvider.jsonAdjustStock["StockTypeCode"] =
                            value.CodigoInterno_TipoEstoque;
                      },
                      value: value.Nome_TipoEstoque,
                      child: FittedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                adjustStockProvider.justificationHasStockType
                                    ? adjustStockProvider
                                        .justificationStockTypeName
                                    : value.Nome_TipoEstoque,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const Divider(
                              height: 4,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
