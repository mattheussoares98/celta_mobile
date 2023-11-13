import 'package:celta_inventario/components/Buy_request/buy_request_dropdownformfield.dart';
import 'package:celta_inventario/providers/buy_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuyRequestBuyersDropwodn extends StatefulWidget {
  const BuyRequestBuyersDropwodn({Key? key}) : super(key: key);

  @override
  State<BuyRequestBuyersDropwodn> createState() =>
      _BuyRequestBuyersDropwodnState();
}

class _BuyRequestBuyersDropwodnState extends State<BuyRequestBuyersDropwodn> {
  final GlobalKey<FormFieldState> _keyBuyers = GlobalKey();

  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context);
    return Column(
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
                          value: value.Name,
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
                  : () async {
                      _keyBuyers.currentState?.reset();

                      await buyRequestProvider.getBuyers(
                        isSearchingAgain: true,
                        context: context,
                      );
                    },
              tooltip: "Pesquisar compradores novamente",
              icon: Icon(
                Icons.refresh,
                color: buyRequestProvider.isLoadingBuyer
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
