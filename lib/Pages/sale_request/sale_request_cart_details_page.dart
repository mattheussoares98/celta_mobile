import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
import '../../components/sale_request/sale_request.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';

class SaleRequestCartDetailsPage extends StatefulWidget {
  final int enterpriseCode;
  final int requestTypeCode;
  final bool keyboardIsOpen;
  const SaleRequestCartDetailsPage({
    required this.enterpriseCode,
    required this.requestTypeCode,
    required this.keyboardIsOpen,
    Key? key,
  }) : super(key: key);

  @override
  State<SaleRequestCartDetailsPage> createState() =>
      _SaleRequestCartDetailsPageState();
}

class _SaleRequestCartDetailsPageState
    extends State<SaleRequestCartDetailsPage> {
  TextEditingController _textEditingController = TextEditingController();

  String textButtonMessage(SaleRequestProvider saleRequestProvider) {
    if (saleRequestProvider
            .cartProductsCount(widget.enterpriseCode.toString()) ==
        0) {
      return "INSIRA PRODUTOS";
    } else if (saleRequestProvider
            .getSelectedCustomerCode(widget.enterpriseCode.toString()) ==
        -1) {
      return "INFORME O CLIENTE";
    } else if (saleRequestProvider.updatedCart) {
      return "CALCULAR PREÇOS";
    } else {
      return "SALVAR PEDIDO";
    }
  }

  saveSaleRequestFunction(SaleRequestProvider saleRequestProvider) {
    if (saleRequestProvider.isLoadingSaveSaleRequest ||
        saleRequestProvider.isLoadingProcessCart) {
      return null;
    } else if (saleRequestProvider
            .getSelectedCustomerCode(widget.enterpriseCode.toString()) ==
        -1) {
      return null;
    } else if (saleRequestProvider
            .cartProductsCount(widget.enterpriseCode.toString()) ==
        0) {
      return null;
    } else if (saleRequestProvider.updatedCart) {
      return () => {
            ShowAlertDialog.showAlertDialog(
              context: context,
              title: "Calcular preços?",
              confirmMessage: "CALCULAR",
              cancelMessage: "CANCELAR",
              subtitle:
                  "Os preços dos produtos devem ser calculados pelo CeltaBS devido a grande variedade de configurações que podem afetar o preço dos produtos (negociação de vendas, preço de oferta, preço de atacado, promoção, etc)",
              function: () async {
                await saleRequestProvider.processCart(
                  context: context,
                  enterpriseCode: widget.enterpriseCode,
                  requestTypeCode: widget.requestTypeCode,
                  customerCode: saleRequestProvider.getSelectedCustomerCode(
                    widget.enterpriseCode.toString(),
                  ),
                  covenantCode: saleRequestProvider.getSelectedCovenantCode(
                      widget.enterpriseCode.toString()),
                );
              },
            )
          };
    } else {
      return () => {
            ShowAlertDialog.showAlertDialog(
              context: context,
              title: "Salvar pedido",
              subtitle: "Deseja salvar o pedido?",
              function: () async {
                await saleRequestProvider.saveSaleRequest(
                  enterpriseCode: widget.enterpriseCode.toString(),
                  requestTypeCode: widget.requestTypeCode,
                  context: context,
                );
              },
            )
          };
    }
  }

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider =
        Provider.of(context, listen: true);

    int cartProductsCount =
        saleRequestProvider.cartProductsCount(widget.enterpriseCode.toString());

    double totalCartPrice =
        saleRequestProvider.getTotalCartPrice(widget.enterpriseCode.toString());

    return Column(
      children: [
        SaleRequestCartItems(
          enterpriseCode: widget.enterpriseCode,
          textEditingController: _textEditingController,
        ),
        if (saleRequestProvider
                .cartProductsCount(widget.enterpriseCode.toString()) ==
            0)
          Expanded(
            child: Container(
              color: Colors.grey[200],
              width: double.infinity,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FittedBox(
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
        if (widget.keyboardIsOpen)
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
                        flex: 15,
                        child: Column(
                          children: [
                            const FittedBox(
                              child: Text(
                                "ITENS",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            FittedBox(
                              child: Text(
                                cartProductsCount.toString(),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 40,
                        child: Column(
                          children: [
                            const Text(
                              "TOTAL",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            FittedBox(
                              child: Text(
                                ConvertString.convertToBRL(
                                  totalCartPrice,
                                ),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
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
                            onPressed:
                                saveSaleRequestFunction(saleRequestProvider),
                            child: saleRequestProvider
                                        .isLoadingSaveSaleRequest ||
                                    saleRequestProvider.isLoadingProcessCart
                                ? FittedBox(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(saleRequestProvider
                                                .isLoadingSaveSaleRequest
                                            ? "SALVANDO PEDIDO   "
                                            : "CALCULANDO PREÇOS   "),
                                        Container(
                                          height: 20,
                                          width: 20,
                                          child:
                                              const CircularProgressIndicator(
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
