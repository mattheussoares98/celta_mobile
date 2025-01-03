import 'package:celta_inventario/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../utils/utils.dart';

class SaveSaleRequestInformationsAndButton extends StatelessWidget {
  final int enterpriseCode;
  final int requestTypeCode;
  final String instructions;
  final String observations;
  const SaveSaleRequestInformationsAndButton({
    required this.enterpriseCode,
    required this.requestTypeCode,
    required this.instructions,
    required this.observations,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String textButtonMessage(SaleRequestProvider saleRequestProvider) {
      if (saleRequestProvider.cartProductsCount(enterpriseCode.toString()) ==
          0) {
        return "INSIRA PRODUTOS";
      } else if (saleRequestProvider
              .getSelectedCustomerCode(enterpriseCode.toString()) ==
          -1) {
        return "INFORME O CLIENTE";
      } else if (saleRequestProvider.needProcessCart) {
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
              .getSelectedCustomerCode(enterpriseCode.toString()) ==
          -1) {
        return null;
      } else if (saleRequestProvider
              .cartProductsCount(enterpriseCode.toString()) ==
          0) {
        return null;
      } else if (saleRequestProvider.needProcessCart) {
        return () => {
              ShowAlertDialog.show(
                context: context,
                title: "Calcular preços?",
                confirmMessage: "CALCULAR",
                cancelMessage: "CANCELAR",
                content: const SingleChildScrollView(
                  child: Text(
                    "Os preços dos produtos devem ser calculados pelo CeltaBS devido a grande variedade de configurações que podem afetar o preço dos produtos (negociação de vendas, preço de oferta, preço de atacado, promoção, etc)",
                    textAlign: TextAlign.center,
                  ),
                ),
                function: () async {
                  await saleRequestProvider.processCart(
                    context: context,
                    enterpriseCode: enterpriseCode,
                    requestTypeCode: requestTypeCode,
                    customerCode: saleRequestProvider.getSelectedCustomerCode(
                      enterpriseCode.toString(),
                    ),
                    covenantCode: saleRequestProvider
                        .getSelectedCovenantCode(enterpriseCode.toString()),
                  );
                },
              )
            };
      } else {
        return () => {
              ShowAlertDialog.show(
                context: context,
                title: "Salvar pedido",
                content: const SingleChildScrollView(
                  child: Text(
                    "Deseja salvar o pedido?",
                    textAlign: TextAlign.center,
                  ),
                ),
                function: () async {
                  await saleRequestProvider.saveSaleRequest(
                    enterpriseCode: enterpriseCode.toString(),
                    requestTypeCode: requestTypeCode,
                    context: context,
                    instructions: instructions,
                    observations: observations,
                  );
                },
              )
            };
      }
    }

    SaleRequestProvider saleRequestProvider = Provider.of(context);

    int cartProductsCount =
        saleRequestProvider.cartProductsCount(enterpriseCode.toString());

    double totalCartPrice =
        saleRequestProvider.getTotalCartPrice(enterpriseCode.toString());
    return Container(
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
                      onPressed: saveSaleRequestFunction(saleRequestProvider),
                      child: Padding(
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
    );
  }
}
