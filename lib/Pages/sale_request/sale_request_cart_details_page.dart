import 'package:celta_inventario/Components/Sale_request/sale_request_cart_items.dart';
import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:celta_inventario/utils/convert_string.dart';
import 'package:celta_inventario/utils/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaleRequestCartDetailsPage extends StatefulWidget {
  final int enterpriseCode;
  final int requestTypeCode;
  const SaleRequestCartDetailsPage({
    required this.enterpriseCode,
    required this.requestTypeCode,
    Key? key,
  }) : super(key: key);

  @override
  State<SaleRequestCartDetailsPage> createState() =>
      _SaleRequestCartDetailsPageState();
}

String textButtonMessage(SaleRequestProvider saleRequestProvider) {
  if (saleRequestProvider.cartProductsCount == 0) {
    return "INSIRA PRODUTOS";
  } else if (saleRequestProvider.costumerCode == -1) {
    return "INFORME O CLIENTE";
  } else {
    return "SALVAR PEDIDO";
  }
}

class _SaleRequestCartDetailsPageState
    extends State<SaleRequestCartDetailsPage> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider =
        Provider.of(context, listen: true);

    int cartProductsCount =
        saleRequestProvider.cartProductsCount(widget.enterpriseCode);

    double totalCartPrice =
        saleRequestProvider.getTotalCartPrice(widget.enterpriseCode);

    return Column(
      children: [
        SaleRequestCartItems(
          enterpriseCode: widget.enterpriseCode,
          textEditingController: _textEditingController,
        ),
        if (saleRequestProvider.cartProductsCount == 0)
          Expanded(
            child: Container(
              color: Colors.grey[200],
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const FittedBox(
                    child: Text(
                      "O carrinho está vazio",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontFamily: "OpenSans",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (saleRequestProvider.lastSaleRequestSaved != "")
          Container(
            color: Colors.grey[200],
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(
                child: Text(
                  saleRequestProvider.lastSaleRequestSaved,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    fontStyle: FontStyle.italic,
                    fontFamily: "OpenSans",
                  ),
                ),
              ),
            ),
          ),
        Container(
          color: Colors.grey[400],
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 20,
                      child: Column(
                        children: [
                          const Text(
                            "ITENS",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            cartProductsCount.toString(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 20,
                      child: Column(
                        children: [
                          const Text(
                            "TOTAL",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            ConvertString.convertToBRL(
                              totalCartPrice,
                            ),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 60,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ElevatedButton(
                          onPressed: saleRequestProvider
                                      .isLoadingSaveSaleRequest ||
                                  saleRequestProvider.costumerCode == -1 ||
                                  saleRequestProvider.cartProductsCount == 0
                              ? null
                              : () async {
                                  ShowAlertDialog().showAlertDialog(
                                    context: context,
                                    title: "Salvar pedido",
                                    subtitle: "Deseja salvar o pedido?",
                                    function: () async {
                                      await saleRequestProvider.saveSaleRequest(
                                        enterpriseCode: widget.enterpriseCode,
                                        requestTypeCode: widget.requestTypeCode,
                                        context: context,
                                      );
                                    },
                                  );
                                },
                          child: saleRequestProvider.isLoadingSaveSaleRequest
                              ? FittedBox(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text("SALVANDO PEDIDO   "),
                                      Container(
                                        height: 20,
                                        width: 20,
                                        child: const CircularProgressIndicator(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FittedBox(
                                    child: Text(
                                      textButtonMessage(saleRequestProvider),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
