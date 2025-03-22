import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../Models/models.dart';
import '../../../../providers/providers.dart';
import '../../../../utils/utils.dart';

class QuantityInCartAndRemoveProduct extends StatelessWidget {
  final GetProductJsonModel product;
  final TransferRequestEnterpriseModel originEnterprise;
  final TransferRequestEnterpriseModel destinyEnterprise;
  final TransferRequestModel selectedTransferRequestModel;
  const QuantityInCartAndRemoveProduct({
    required this.product,
    required this.originEnterprise,
    required this.destinyEnterprise,
    required this.selectedTransferRequestModel,
    super.key,
  });

  void removeProduct(
    TransferRequestProvider transferRequestProvider,
    BuildContext context,
  ) {
    ShowAlertDialog.show(
      context: context,
      title: "Confirmar exclusão",
      content: const SingleChildScrollView(
        child: Text(
          "Deseja excluir o produto do carrinho?",
          textAlign: TextAlign.center,
        ),
      ),
      function: () {
        transferRequestProvider.removeProductFromCart(
          ProductPackingCode: product.productPackingCode,
          enterpriseDestinyCode: destinyEnterprise.Code.toString(),
          enterpriseOriginCode: originEnterprise.Code.toString(),
          requestTypeCode: selectedTransferRequestModel.Code.toString(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TransferRequestProvider transferRequestProvider = Provider.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            "Qtd: " +
                transferRequestProvider
                    .getTotalItensInCart(
                      ProductPackingCode: product.productPackingCode,
                      enterpriseOriginCode: originEnterprise.Code.toString(),
                      enterpriseDestinyCode: destinyEnterprise.Code.toString(),
                      requestTypeCode:
                          selectedTransferRequestModel.Code.toString(),
                    )
                    .toString()
                    .toBrazilianNumber(3),
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              removeProduct(
                transferRequestProvider,
                context,
              );
            },
            child: const FittedBox(
              child: Row(
                children: [
                  Text(
                    "Remover produto",
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
