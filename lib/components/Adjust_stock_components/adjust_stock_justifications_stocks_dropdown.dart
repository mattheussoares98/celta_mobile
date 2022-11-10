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
  final GlobalKey<FormFieldState> _keyJustifications = GlobalKey();
  final GlobalKey<FormFieldState> _keyStockType = GlobalKey();

  String _justificationStockTypeName = "";
  bool _justificationHasStockType = false;
  //se a justificativa possuir um código de estoque atrelado, significa que
  //somente esse estoque pode ser alterado quando selecionar essa justificativa.
  //Por isso, quando selecionar a justificativa, está validando se ela possui um
  //estoque atrelado e caso tenha, desativa o dropdown de tipo de estoque,
  //altera o nome do dropdown do tipo de estoque e atualiza o código do estoque
  //que precisa ser enviado na requisição do json

  @override
  Widget build(BuildContext context) {
    if (widget.adjustStockProvider.isLoadingTypeStockAndJustifications) {
      _keyJustifications.currentState?.reset();
      _keyStockType.currentState?.reset();
    }
    return Form(
      key: widget.dropDownFormKey,
      child: FittedBox(
        child: Container(
          margin: const EdgeInsets.only(left: 5, right: 5, bottom: 3),
          height: 130,
          child: Row(
            children: [
              Container(
                height: double.infinity,
                alignment: widget.adjustStockProvider.isLoadingAdjustStock
                    ? Alignment.center
                    : Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width / 2 - 8,
                child: DropdownButtonFormField<dynamic>(
                  isDense: false,
                  key: _keyJustifications,
                  disabledHint: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            widget.adjustStockProvider
                                    .isLoadingTypeStockAndJustifications
                                ? "Consultando"
                                : "Justificativas",
                            overflow: TextOverflow.visible,
                            softWrap: true,
                            maxLines: 4,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                          // print(value);
                        },
                  items: widget.adjustStockProvider.justifications
                      .map(
                        (value) => DropdownMenuItem(
                          onTap: () {
                            widget.adjustStockProvider
                                    .jsonAdjustStock["JustificationCode"] =
                                value.Code.toString();

                            if (value.StockType["Code"] != null) {
                              //se no tipo de justificativa houver um código
                              //atrelado, somente esse estoque pode ser
                              //alterado. Por isso a aplicação desativa o
                              //outro tropdown e atribui o código ao json que
                              //precisa ser enviado na requisição do tipo de
                              //estoque

                              setState(() {
                                _justificationHasStockType = true;
                              });

                              widget.adjustStockProvider
                                      .jsonAdjustStock["StockTypeCode"] =
                                  value.StockType["Code"];
                            } else {
                              setState(() {
                                _justificationHasStockType = false;
                              });
                            }
                            widget.adjustStockProvider.typeOperator = value
                                .TypeOperator; //usado pra aplicação saber se precisa somar ou subtrair o valor do estoque atual

                            if (value.StockType["Name"] ==
                                _justificationStockTypeName) {
                              //se a variável já estiver com o mesmo nome do
                              //tipo de estoque não precisa alterar
                              return;
                            } else if (value.StockType["Name"] != null) {
                              setState(() {
                                _justificationStockTypeName =
                                    value.StockType["Name"];

                                widget.adjustStockProvider.stockTypeName =
                                    value.StockType["Name"];
                                //quando for o estoque atual, se der certo a alteração, vai alterar a quantidade do estoque atual do produto
                              });
                            }
                          },
                          value: value.Description,
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  value.Description,
                                ),
                              ),
                              const Divider(
                                height: 4,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: double.infinity,
                alignment: widget.adjustStockProvider.isLoadingAdjustStock ||
                        _justificationHasStockType
                    ? Alignment.center
                    : Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width / 2 - 8,
                child: DropdownButtonFormField<dynamic>(
                  isDense: false,
                  key: _keyStockType,
                  disabledHint: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            widget.adjustStockProvider
                                    .isLoadingTypeStockAndJustifications
                                ? "Consultando"
                                : _justificationHasStockType
                                    ? _justificationStockTypeName
                                    : "Tipos de estoque",
                            overflow: TextOverflow.visible,
                            softWrap: true,
                            maxLines: 4,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                    if (_justificationHasStockType) {
                      return null;
                    } else if (value == null) {
                      return 'Selecione um tipo de estoque!';
                    }
                    return null;
                  },
                  onChanged: widget.adjustStockProvider
                              .isLoadingTypeStockAndJustifications ||
                          widget.adjustStockProvider.isLoadingAdjustStock ||
                          _justificationHasStockType
                      ? null
                      : (value) {},
                  items: widget.adjustStockProvider.stockTypes
                      .map(
                        (value) => DropdownMenuItem(
                          onTap: () {
                            widget.adjustStockProvider
                                    .jsonAdjustStock["StockTypeCode"] =
                                value.Code.toString();
                            widget.adjustStockProvider.stockTypeName =
                                value.Name;
                          },
                          value: value.Name,
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  _justificationHasStockType
                                      ? _justificationStockTypeName
                                      : value.Name,
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                  maxLines: 4,
                                  style: TextStyle(
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
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
