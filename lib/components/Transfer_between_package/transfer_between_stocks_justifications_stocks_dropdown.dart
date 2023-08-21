import 'package:celta_inventario/providers/transfer_between_package_provider_SemImplementacaoAinda.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransferBetweenPackageJustificationsAndStocksDropwdownWidget
    extends StatefulWidget {
  final GlobalKey<FormState> dropDownFormKey;

  const TransferBetweenPackageJustificationsAndStocksDropwdownWidget({
    required this.dropDownFormKey,
    Key? key,
  }) : super(key: key);

  @override
  State<TransferBetweenPackageJustificationsAndStocksDropwdownWidget>
      createState() =>
          _TransferBetweenPackageJustificationsAndStocksDropwdownWidgetState();
}

class _TransferBetweenPackageJustificationsAndStocksDropwdownWidgetState
    extends State<
        TransferBetweenPackageJustificationsAndStocksDropwdownWidget> {
  final GlobalKey<FormFieldState> _keyJustifications = GlobalKey();
  final GlobalKey<FormFieldState> _keyOriginStockType = GlobalKey();
  final GlobalKey<FormFieldState> _keyDestinyStockType = GlobalKey();

  //se a justificativa possuir um código de estoque atrelado, significa que
  //somente esse estoque pode ser alterado quando selecionar essa justificativa.
  //Por isso, quando selecionar a justificativa, está validando se ela possui um
  //estoque atrelado e caso tenha, desativa o dropdown de tipo de estoque,
  //altera o nome do dropdown do tipo de estoque e atualiza o código do estoque
  //que precisa ser enviado na requisição do json

  @override
  Widget build(BuildContext context) {
    TransferBetweenPackageProvider transferBetweenPackageProvider =
        Provider.of(context);

    if (transferBetweenPackageProvider.isLoadingTypeStockAndJustifications) {
      _keyJustifications.currentState?.reset();
      _keyOriginStockType.currentState?.reset();
      _keyDestinyStockType.currentState?.reset();
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
              disabledHint: transferBetweenPackageProvider
                      .isLoadingTypeStockAndJustifications
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
              onChanged: transferBetweenPackageProvider
                          .isLoadingTypeStockAndJustifications ||
                      transferBetweenPackageProvider.isLoadingAdjustStock ||
                      transferBetweenPackageProvider.isLoadingProducts ||
                      transferBetweenPackageProvider.products.isEmpty
                  ? null
                  : (value) {
                      print(value);
                    },
              items: transferBetweenPackageProvider.justifications
                  .map(
                    (value) => DropdownMenuItem(
                      alignment: Alignment.center,
                      onTap: () {
                        transferBetweenPackageProvider
                                .jsonAdjustStock["JustificationCode"] =
                            value.CodigoInterno_JustMov;

                        if (value.CodigoInterno_TipoEstoque
                                .CodigoInterno_TipoEstoque !=
                            -1) {
                          transferBetweenPackageProvider
                              .justificationHasStockType = true;

                          setState(() {
                            transferBetweenPackageProvider
                                .updateJustificationStockTypeName(
                              value.CodigoInterno_TipoEstoque.Nome_TipoEstoque,
                            );
                          });
                        } else {
                          transferBetweenPackageProvider
                              .justificationHasStockType = false;
                        }

                        transferBetweenPackageProvider.typeOperator = value
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
              disabledHint: transferBetweenPackageProvider
                      .isLoadingTypeStockAndJustifications
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
                        transferBetweenPackageProvider.justificationHasStockType
                            ? transferBetweenPackageProvider
                                .justificationStockTypeName
                            : "Embalagem de origem",
                      ),
                    ),
              isExpanded: true,
              hint: Center(
                child: Text(
                  'Embalagem de origem',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              validator: (value) {
                if (transferBetweenPackageProvider.justificationHasStockType) {
                  return null;
                } else if (value == null) {
                  return 'Selecione um tipo de estoque!';
                }
                return null;
              },
              onChanged: transferBetweenPackageProvider
                          .isLoadingTypeStockAndJustifications ||
                      transferBetweenPackageProvider.isLoadingAdjustStock ||
                      transferBetweenPackageProvider.isLoadingProducts ||
                      transferBetweenPackageProvider
                          .justificationHasStockType ||
                      transferBetweenPackageProvider.products.isEmpty
                  ? null
                  : (value) {},
              items: transferBetweenPackageProvider.originStockTypes
                  .map(
                    (value) => DropdownMenuItem(
                      alignment: Alignment.center,
                      onTap: () {
                        transferBetweenPackageProvider
                                .jsonAdjustStock["StockTypeCode"] =
                            value.CodigoInterno_TipoEstoque;
                      },
                      value: value.Nome_TipoEstoque,
                      child: FittedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                transferBetweenPackageProvider
                                        .justificationHasStockType
                                    ? transferBetweenPackageProvider
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
            DropdownButtonFormField<dynamic>(
              // isDense: false,
              key: _keyDestinyStockType,
              disabledHint: transferBetweenPackageProvider
                      .isLoadingTypeStockAndJustifications
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
                  : const Center(
                      child: Text(
                        "Embalagem de destino",
                      ),
                    ),
              isExpanded: true,
              hint: Center(
                child: Text(
                  'Embalagem de destino',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              validator: (value) {
                if (value == null) {
                  return 'Selecione um tipo de estoque!';
                } else if (transferBetweenPackageProvider
                        .jsonAdjustStock["StockTypeCode"] ==
                    transferBetweenPackageProvider
                        .jsonAdjustStock["StockTypeRecipientCode"]) {
                  return "Os estoques devem ser diferentes!";
                }
                return null;
              },
              onChanged: transferBetweenPackageProvider
                          .isLoadingTypeStockAndJustifications ||
                      transferBetweenPackageProvider.isLoadingAdjustStock ||
                      transferBetweenPackageProvider.isLoadingProducts ||
                      transferBetweenPackageProvider.products.isEmpty
                  ? null
                  : (value) {
                      print("mudou o value $value");
                    },
              items: transferBetweenPackageProvider.destinyStockTypes
                  .map(
                    (value) => DropdownMenuItem(
                      alignment: Alignment.center,
                      onTap: () {
                        transferBetweenPackageProvider
                                .jsonAdjustStock["StockTypeRecipientCode"] =
                            value.CodigoInterno_TipoEstoque;
                      },
                      value: value.Nome_TipoEstoque,
                      child: FittedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                value.Nome_TipoEstoque,
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
