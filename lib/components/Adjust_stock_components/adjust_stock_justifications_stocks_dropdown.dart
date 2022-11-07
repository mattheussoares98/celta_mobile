import 'package:celta_inventario/providers/adjust_stock_provider.dart';
import 'package:flutter/material.dart';

class AdjustStockJustificationsStockDropwdownWidget extends StatefulWidget {
  final AdjustStockProvider adjustStockProvider;
  final GlobalKey<FormState> dropDownFormKey;
  const AdjustStockJustificationsStockDropwdownWidget({
    required this.adjustStockProvider,
    required this.dropDownFormKey,
    Key? key,
  }) : super(key: key);

  @override
  State<AdjustStockJustificationsStockDropwdownWidget> createState() =>
      _AdjustStockJustificationsStockDropwdownWidgetState();
}

class _AdjustStockJustificationsStockDropwdownWidgetState
    extends State<AdjustStockJustificationsStockDropwdownWidget> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.dropDownFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            if (widget.adjustStockProvider
                    .errorMessageTypeStockAndJustifications ==
                "")
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 8,
                    child: DropdownButtonFormField<dynamic>(
                      disabledHint: const Center(child: Text("Consultando")),
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
                      onChanged: widget.adjustStockProvider
                                  .isLoadingTypeStockAndJustifications ||
                              widget.adjustStockProvider.isLoadingAdjustStock
                          ? null
                          : (value) {
                              print(value);
                            },
                      items: widget.adjustStockProvider.justifications
                          .map(
                            (value) => DropdownMenuItem(
                              onTap: () {
                                widget.adjustStockProvider
                                        .jsonAdjustStock["JustificationCode"] =
                                    value.Code.toString();
                                print(value.Code);
                                //value.Code é o código que deve usar na requisição pra confirmar a atualização do estoque
                              },
                              value: value.Description,
                              child: Text(value.Description),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 8,
                    child: DropdownButtonFormField<dynamic>(
                      disabledHint: const Center(child: Text("Consultando")),
                      isExpanded: true,
                      hint: Center(
                        child: Text(
                          'Tipos de estoque',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Selecione um tipo de estoque!';
                        }
                        return null;
                      },
                      onChanged: widget.adjustStockProvider
                                  .isLoadingTypeStockAndJustifications ||
                              widget.adjustStockProvider.isLoadingAdjustStock
                          ? null
                          : (value) {
                              print(value);
                            },
                      items: widget.adjustStockProvider.stockTypes
                          .map(
                            (value) => DropdownMenuItem(
                              onTap: () {
                                widget.adjustStockProvider
                                        .jsonAdjustStock["StockTypeCode"] =
                                    value.Code.toString();
                                print(value.Code);
                                //value.Code é o código que deve usar na requisição pra confirmar a atualização do estoque
                              },
                              value: value.Name,
                              child: Text(value.Name),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            if (widget.adjustStockProvider
                    .errorMessageTypeStockAndJustifications !=
                "")
              TextButton(
                onPressed: widget
                        .adjustStockProvider.isLoadingTypeStockAndJustifications
                    ? null
                    : () async {
                        await widget.adjustStockProvider
                            .getStockTypeAndJustifications(context);
                      },
                child: Text(
                  widget.adjustStockProvider.isLoadingTypeStockAndJustifications
                      ? "Consultando justificativas e tipos de estoque"
                      : "Consultar justificativas e tipos de estoque novamente",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
