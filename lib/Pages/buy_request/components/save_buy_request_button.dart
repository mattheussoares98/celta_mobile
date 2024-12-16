import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/providers.dart';
import '../../../utils/utils.dart';
import '../../../components/components.dart';

class SaveBuyRequestButton extends StatefulWidget {
  const SaveBuyRequestButton({
    Key? key,
  }) : super(key: key);

  @override
  State<SaveBuyRequestButton> createState() => _SaveBuyRequestButtonState();
}

class _SaveBuyRequestButtonState extends State<SaveBuyRequestButton> {
  String textButtonMessage(BuyRequestProvider buyRequestProvider) {
    if (buyRequestProvider.selectedBuyer == null) {
      return "Informe o comprador";
    } else if (buyRequestProvider.selectedRequestModel == null) {
      return "Informe o modelo de pedido";
    } else if (buyRequestProvider.selectedSupplier == null) {
      return "Selecione o fornecedor";
    } else if (!buyRequestProvider.hasSelectedEnterprise) {
      return "Selecione a empresa";
    } else if (buyRequestProvider.productsInCartCount == 0) {
      return "Insira produtos";
    } else {
      return "Salvar pedido";
    }
  }

  bool _canSaveBuyRequest(BuyRequestProvider buyRequestProvider) {
    return !buyRequestProvider.isLoadingInsertBuyRequest &&
        buyRequestProvider.selectedBuyer != null &&
        buyRequestProvider.selectedRequestModel != null &&
        buyRequestProvider.selectedSupplier != null &&
        buyRequestProvider.hasSelectedEnterprise &&
        buyRequestProvider.productsInCartCount > 0;
  }

  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context);
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
                          buyRequestProvider.productsInCartCount.toString(),
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
                            buyRequestProvider.totalCartPrice,
                            decimalHouses: 4,
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
                      onPressed: !_canSaveBuyRequest(buyRequestProvider)
                          ? null
                          : () async {
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
                                  await buyRequestProvider
                                      .insertBuyRequest(context);
                                },
                              );
                            },
                      child: buyRequestProvider.isLoadingInsertBuyRequest
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
                                  textButtonMessage(buyRequestProvider),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    fontSize: 17,
                                    color:
                                        !_canSaveBuyRequest(buyRequestProvider)
                                            ? Colors.red
                                            : Colors.white,
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
