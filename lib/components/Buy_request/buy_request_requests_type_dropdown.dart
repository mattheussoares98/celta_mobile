import 'package:celta_inventario/components/Buy_request/buy_request_dropdownformfield.dart';
import 'package:celta_inventario/providers/buy_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuyRequestRequestsTypeDropdown extends StatefulWidget {
  const BuyRequestRequestsTypeDropdown({Key? key}) : super(key: key);

  @override
  State<BuyRequestRequestsTypeDropdown> createState() =>
      _BuyRequestRequestsTypeDropdownState();
}

class _BuyRequestRequestsTypeDropdownState
    extends State<BuyRequestRequestsTypeDropdown> {
  final GlobalKey<FormFieldState> _keyRequests = GlobalKey();

  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                                // Center(
                                //   child: Text(
                                //     value.UnitValueTypeString
                                //         .toString(),
                                //   ),
                                // ),
                                // Center(
                                //   child: Text(
                                //     value.UseWholePriceString
                                //         .toString(),
                                //   ),
                                // ),
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
                  : () async {
                      _keyRequests.currentState?.reset();

                      await buyRequestProvider.getRequestsType(
                        context: context,
                        isSearchingAgain: true,
                      );
                    },
              tooltip: "Pesquisar modelos de pedido novamente",
              icon: Icon(
                Icons.refresh,
                color: buyRequestProvider.isLoadingRequestsType
                    ? Colors.grey
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
