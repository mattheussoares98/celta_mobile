import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../Models/models.dart';
import './components/components.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';

class CartDetailsPage extends StatefulWidget {
  final TransferRequestEnterpriseModel originEnterprise;
  final TransferRequestEnterpriseModel destinyEnterprise;
  final TransferRequestModel selectedTransferRequestModel;
  final bool keyboardIsOpen;
  const CartDetailsPage({
    required this.originEnterprise,
    required this.destinyEnterprise,
    required this.selectedTransferRequestModel,
    required this.keyboardIsOpen,
    Key? key,
  }) : super(key: key);

  @override
  State<CartDetailsPage> createState() => _CartDetailsPageState();
}

class _CartDetailsPageState extends State<CartDetailsPage> {
  String textButtonMessage({
    required TransferRequestProvider transferRequestProvider,
    required String? enterpriseOriginCode,
    required String? enterpriseDestinyCode,
    required String? requestTypeCode,
  }) {
    if (transferRequestProvider.cartProductsCount(
          enterpriseOriginCode: enterpriseOriginCode,
          enterpriseDestinyCode: enterpriseDestinyCode,
          requestTypeCode: requestTypeCode,
        ) ==
        0) {
      return "INSIRA PRODUTOS";
    } else {
      return "SALVAR TRANSFERÊNCIA";
    }
  }

  dynamic saveTransferRequestFunction({
    required TransferRequestProvider transferRequestProvider,
  }) {
    if (transferRequestProvider.isLoadingSaveTransferRequest) {
      return null;
    } else if (transferRequestProvider.cartProductsCount(
          enterpriseOriginCode: widget.originEnterprise.Code?.toString(),
          enterpriseDestinyCode: widget.destinyEnterprise.Code?.toString(),
          requestTypeCode: widget.selectedTransferRequestModel.Code?.toString(),
        ) ==
        0) {
      return null;
    } else {
      return () => {
            ShowAlertDialog.show(
              context: context,
              title: "Salvar pedido de transferência",
              content: const SingleChildScrollView(
                child: Text(
                  "Deseja salvar o pedido de transferência?",
                  textAlign: TextAlign.center,
                ),
              ),
              function: () async {
                await transferRequestProvider.saveTransferRequest(
                  enterpriseOriginCode: widget.originEnterprise.Code.toString(),
                  enterpriseDestinyCode:
                      widget.destinyEnterprise.Code.toString(),
                  requestTypeCode:
                      widget.selectedTransferRequestModel.Code.toString(),
                  context: context,
                );
              },
            )
          };
    }
  }

  @override
  Widget build(BuildContext context) {
    TransferRequestProvider transferRequestProvider =
        Provider.of(context, listen: true);

    int cartProductsCount = transferRequestProvider.cartProductsCount(
      enterpriseOriginCode: widget.originEnterprise.Code?.toString(),
      enterpriseDestinyCode: widget.destinyEnterprise.Code?.toString(),
      requestTypeCode: widget.selectedTransferRequestModel.Code?.toString(),
    );

    double totalCartPrice = transferRequestProvider.getTotalCartPrice(
      enterpriseOriginCode: widget.originEnterprise.Code?.toString(),
      enterpriseDestinyCode: widget.destinyEnterprise.Code?.toString(),
      requestTypeCode: widget.selectedTransferRequestModel.Code?.toString(),
    );

    return Column(
      children: [
        CartItems(
          originEnterprise: widget.originEnterprise,
          destinyEnterprise: widget.destinyEnterprise,
          selectedTransferRequestModel: widget.selectedTransferRequestModel,
        ),
        if (transferRequestProvider.cartProductsCount(
              enterpriseOriginCode: widget.originEnterprise.Code?.toString(),
              enterpriseDestinyCode: widget.destinyEnterprise.Code?.toString(),
              requestTypeCode:
                  widget.selectedTransferRequestModel.Code?.toString(),
            ) ==
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
        if (transferRequestProvider.lastSavedTransferRequest != "")
          Container(
            color: Colors.grey[200],
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(
                child: Text(
                  transferRequestProvider.lastSavedTransferRequest,
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
                            onPressed: saveTransferRequestFunction(
                              transferRequestProvider: transferRequestProvider,
                            ),
                            child: transferRequestProvider
                                    .isLoadingSaveTransferRequest
                                ? FittedBox(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Text("SALVANDO TRANSFERÊNCIA   "),
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
                                : FittedBox(
                                    child: Text(
                                      textButtonMessage(
                                        transferRequestProvider:
                                            transferRequestProvider,
                                        enterpriseOriginCode: widget
                                            .originEnterprise.Code
                                            .toString(),
                                        enterpriseDestinyCode: widget
                                            .destinyEnterprise.Code
                                            .toString(),
                                        requestTypeCode: widget
                                            .selectedTransferRequestModel.Code
                                            .toString(),
                                      ),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
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
