import 'package:celta_inventario/components/Buy_request/buy_request_dropdownformfield.dart';
import 'package:celta_inventario/providers/buy_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuyRequestIdentificationPage extends StatefulWidget {
  const BuyRequestIdentificationPage({Key? key}) : super(key: key);

  @override
  State<BuyRequestIdentificationPage> createState() =>
      _BuyRequestIdentificationPageState();
}

class _BuyRequestIdentificationPageState
    extends State<BuyRequestIdentificationPage> {
  final GlobalKey<FormFieldState> _keyBuyers = GlobalKey();
  final GlobalKey<FormFieldState> _keyRequests = GlobalKey();
  final GlobalKey<FormState> _dropDownFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context);
    return Form(
      key: _dropDownFormKey,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Comprador"),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          shape: const RoundedRectangleBorder(),
                          child: BuyRequestDropdownFormfield(
                            dropdownKey: _keyBuyers,
                            isLoading: buyRequestProvider.isLoadingBuyer,
                            disabledHintText: "Comprador",
                            isLoadingMessage: "Consultando compradores",
                            validator: (value) {
                              return "";
                            },
                            items: buyRequestProvider.buyers
                                .map(
                                  (value) => DropdownMenuItem(
                                    alignment: Alignment.center,
                                    onTap: () {
                                      // adjustStockProvider.jsonAdjustStock["JustificationCode"] =
                                      //     value.CodigoInterno_JustMov;

                                      // if (value.CodigoInterno_TipoEstoque
                                      //         .CodigoInterno_TipoEstoque !=
                                      //     -1) {
                                      //   adjustStockProvider.jsonAdjustStock["StockTypeCode"] =
                                      //       value.CodigoInterno_TipoEstoque
                                      //           .CodigoInterno_TipoEstoque;
                                      //   adjustStockProvider.justificationHasStockType = true;

                                      //   setState(() {
                                      //     adjustStockProvider.updateJustificationStockTypeName(
                                      //       value.CodigoInterno_TipoEstoque.Nome_TipoEstoque,
                                      //     );
                                      //   });
                                      // } else {
                                      //   adjustStockProvider.justificationHasStockType = false;
                                      // }

                                      // adjustStockProvider.typeOperator = value
                                      //     .TypeOperator; //usado pra aplicação saber se precisa somar ou subtrair o valor do estoque atual
                                    },
                                    value: value.Code,
                                    child: FittedBox(
                                      child: Column(
                                        children: [
                                          Center(
                                            child: Text(
                                              value.Name,
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
                        ),
                      ),
                      IconButton(
                        onPressed: buyRequestProvider.isLoadingBuyer
                            ? null
                            : () async {},
                        tooltip: "Pesquisar compradores novamente",
                        icon: Icon(
                          Icons.refresh,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("Modelo de pedido de compra"),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          shape: const RoundedRectangleBorder(),
                          child: BuyRequestDropdownFormfield(
                            dropdownKey: _keyRequests,
                            isLoading: buyRequestProvider.isLoadingRequestsType,
                            disabledHintText: "Modelo de pedido",
                            isLoadingMessage: "Consultando modelos",
                            validator: (value) {
                              return "";
                            },
                            items: buyRequestProvider.requestsType
                                .map(
                                  (value) => DropdownMenuItem(
                                    alignment: Alignment.center,
                                    onTap: () {
                                      // adjustStockProvider.jsonAdjustStock["JustificationCode"] =
                                      //     value.CodigoInterno_JustMov;

                                      // if (value.CodigoInterno_TipoEstoque
                                      //         .CodigoInterno_TipoEstoque !=
                                      //     -1) {
                                      //   adjustStockProvider.jsonAdjustStock["StockTypeCode"] =
                                      //       value.CodigoInterno_TipoEstoque
                                      //           .CodigoInterno_TipoEstoque;
                                      //   adjustStockProvider.justificationHasStockType = true;

                                      //   setState(() {
                                      //     adjustStockProvider.updateJustificationStockTypeName(
                                      //       value.CodigoInterno_TipoEstoque.Nome_TipoEstoque,
                                      //     );
                                      //   });
                                      // } else {
                                      //   adjustStockProvider.justificationHasStockType = false;
                                      // }

                                      // adjustStockProvider.typeOperator = value
                                      //     .TypeOperator; //usado pra aplicação saber se precisa somar ou subtrair o valor do estoque atual
                                    },
                                    value: value.Code,
                                    child: FittedBox(
                                      child: Column(
                                        children: [
                                          Center(
                                            child: Text(
                                              value.Name.toString(),
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              value.UnitValueTypeString
                                                  .toString(),
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              value.UseWholePriceString
                                                  .toString(),
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
                        ),
                      ),
                      IconButton(
                        onPressed: buyRequestProvider.isLoadingRequestsType
                            ? null
                            : () async {},
                        tooltip: "Pesquisar modelos de pedido novamente",
                        icon: Icon(
                          Icons.refresh,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
