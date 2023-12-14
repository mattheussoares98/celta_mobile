import 'package:celta_inventario/components/Global_widgets/show_alert_dialog.dart';
import 'package:celta_inventario/providers/buy_request_provider.dart';
import 'package:celta_inventario/utils/convert_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuyRequestSave extends StatefulWidget {
  const BuyRequestSave({
    Key? key,
  }) : super(key: key);

  @override
  State<BuyRequestSave> createState() => _BuyRequestSaveState();
}

class _BuyRequestSaveState extends State<BuyRequestSave> {
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
                      onPressed: buyRequestProvider.isLoadingInsertBuyRequest ||
                              buyRequestProvider.selectedBuyer == null ||
                              buyRequestProvider.selectedRequestModel == null ||
                              buyRequestProvider.selectedSupplier == null ||
                              !buyRequestProvider.hasSelectedEnterprise ||
                              buyRequestProvider.productsInCartCount == 0
                          ? null
                          : () async {
                              ShowAlertDialog.showAlertDialog(
                                context: context,
                                title: "Salvar pedido",
                                subtitle: "Deseja salvar o pedido?",
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
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w100,
                                    fontSize: 17,
                                    color: Colors.red,
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
