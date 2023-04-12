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
  final GlobalKey<FormFieldState> _keyStockType = GlobalKey();

  //se a justificativa possuir um código de estoque atrelado, significa que
  //somente esse estoque pode ser alterado quando selecionar essa justificativa.
  //Por isso, quando selecionar a justificativa, está validando se ela possui um
  //estoque atrelado e caso tenha, desativa o dropdown de tipo de estoque,
  //altera o nome do dropdown do tipo de estoque e atualiza o código do estoque
  //que precisa ser enviado na requisição do json

  @override
  Widget build(BuildContext context) {
    AdjustStockProvider adjustStockProvider = Provider.of(context);

    if (adjustStockProvider.isLoadingTypeStockAndJustifications) {
      _keyJustifications.currentState?.reset();
      _keyStockType.currentState?.reset();
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
                          // print(value);
                        },
              items: adjustStockProvider.justifications
                  .map(
                    (value) => DropdownMenuItem(
                      alignment: Alignment.center,
                      onTap: () {
                        adjustStockProvider
                                .jsonAdjustStock["JustificationCode"] =
                            value.Code.toString();

                        if (value.StockType["Code"] != null) {
                          //se no tipo de justificativa houver um código
                          //atrelado, somente esse estoque pode ser
                          //alterado. Por isso a aplicação desativa o
                          //outro tropdown e atribui o código ao json que
                          //precisa ser enviado na requisição do tipo de
                          //estoque

                          adjustStockProvider.justificationHasStockType = true;

                          adjustStockProvider.jsonAdjustStock["StockTypeCode"] =
                              value.StockType["Code"];
                        } else {
                          adjustStockProvider.justificationHasStockType = false;
                        }
                        adjustStockProvider.typeOperator = value
                            .TypeOperator; //usado pra aplicação saber se precisa somar ou subtrair o valor do estoque atual

                        if (value.StockType["Name"] ==
                            adjustStockProvider.justificationStockTypeName) {
                          //se a variável já estiver com o mesmo nome do
                          //tipo de estoque não precisa alterar
                          return;
                        } else if (value.StockType["Name"] != null) {
                          setState(() {
                            adjustStockProvider
                                .updateJustificationStockTypeName(
                              value.StockType["Name"],
                            );

                            adjustStockProvider.stockTypeName =
                                value.StockType["Name"];
                            //quando for o estoque atual, se der certo a alteração, vai alterar a quantidade do estoque atual do produto
                          });
                        }
                      },
                      value: value.Description,
                      child: FittedBox(
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
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<dynamic>(
              // isDense: false,
              key: _keyStockType,
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
                                : "Tipos de estoque",
                          ),
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
                      : (value) {},
              items: adjustStockProvider.stockTypes
                  .map(
                    (value) => DropdownMenuItem(
                      alignment: Alignment.center,
                      onTap: () {
                        adjustStockProvider.jsonAdjustStock["StockTypeCode"] =
                            value.Code.toString();
                        adjustStockProvider.stockTypeName = value.Name;
                      },
                      value: value.Name,
                      child: FittedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                adjustStockProvider.justificationHasStockType
                                    ? adjustStockProvider
                                        .justificationStockTypeName
                                    : value.Name,
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
