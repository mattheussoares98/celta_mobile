import 'package:celta_inventario/providers/adjust_stock_provider.dart';
import 'package:flutter/material.dart';

class AdjustStockJustificationsStockDropwdownWidget extends StatefulWidget {
  final AdjustStockProvider adjustStockProvider;
  const AdjustStockJustificationsStockDropwdownWidget({
    required this.adjustStockProvider,
    Key? key,
  }) : super(key: key);

  @override
  State<AdjustStockJustificationsStockDropwdownWidget> createState() =>
      _AdjustStockJustificationsStockDropwdownWidgetState();
}

class _AdjustStockJustificationsStockDropwdownWidgetState
    extends State<AdjustStockJustificationsStockDropwdownWidget> {
  String? _justifications;
  String? _stockTypes;
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 8,
                  child: DropdownButtonFormField<dynamic>(
                    disabledHint: const Center(child: Text("Consultando")),
                    isExpanded: true,
                    value: _justifications,
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
                      } else if (_justifications == null) {
                        return "Selecione uma justificativa!";
                      }
                      return null;
                    },
                    onChanged: widget.adjustStockProvider
                            .isLoadingTypeStockAndJustifications
                        ? null
                        : (value) {
                            setState(() {
                              _justifications = value!;
                            });
                            if (_formKey.currentState!.validate()) {
                              //form is valid, proceed further
                              _formKey.currentState!
                                  .save(); //save once fields are valid, onSaved method invoked for every form fields
                            }
                            // print("clicou pra alterar $value");
                            // widget.announcementsModel.state = value;
                            print(value);
                          },
                    items: widget.adjustStockProvider.justifications
                        .map(
                          (value) => DropdownMenuItem(
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
                    value: _stockTypes,
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
                            .isLoadingTypeStockAndJustifications
                        ? null
                        : (value) {
                            setState(() {
                              _stockTypes = value!;
                            });
                            if (_formKey.currentState!.validate()) {
                              //form is valid, proceed further
                              _formKey.currentState!
                                  .save(); //save once fields are valid, onSaved method invoked for every form fields
                            }
                            // print("clicou pra alterar $value");
                            // widget.announcementsModel.state = value;
                            print(value);
                          },
                    items: widget.adjustStockProvider.stockTypes
                        .map(
                          (value) => DropdownMenuItem(
                            value: value.Name,
                            child: Text(value.Name),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              child: Text('Salvar'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  //form is valid, proceed further
                  _formKey.currentState!
                      .save(); //save once fields are valid, onSaved method invoked for every form fields
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
