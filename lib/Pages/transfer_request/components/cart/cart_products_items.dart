import 'package:flutter/material.dart';

import '../../../../models/models.dart';
import '../../../../providers/providers.dart';
import '../../../../utils/utils.dart';
import '../../../../components/components.dart';

class CartProductsItems {
  static Widget _titleAndSubtitle({
    required String title,
    required String subtitle,
    required int flex,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 100, 97, 97),
              ),
            ),
            const SizedBox(height: 5),
            FittedBox(
              child: Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  static Widget transferRequestCartProductsItems({
    required TransferRequestProvider transferRequestProvider,
    required dynamic changeFocus,
    required BuildContext context,
    required int index,
    required TransferRequestCartProductsModel product,
    required String enterpriseOriginCode,
    required String enterpriseDestinyCode,
    required String requestTypeCode,
    required int selectedIndex,
    required Function updateSelectedIndex,
  }) {
    return GestureDetector(
      onTap: changeFocus,
      child: Padding(
        padding: const EdgeInsets.only(left: 3, top: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: FittedBox(
                      child: Text(
                        (index + 1).toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 0),
                              blurRadius: 2.0,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                // crossAxisAlignment:
                //     CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.Name +
                              " (${product.PackingQuantity})" +
                              '\nplu: ${product.PLU}',
                          style: const TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: transferRequestProvider
                                .isLoadingSaveTransferRequest
                            ? null
                            : () {
                                ShowAlertDialog.show(
                                  context: context,
                                  title: "Remover item",
                                  content: const SingleChildScrollView(
                                    child: Text(
                                      "Deseja realmente remover o item do carrinho?",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  function: () {
                                    transferRequestProvider
                                        .removeProductFromCart(
                                      ProductPackingCode:
                                          product.ProductPackingCode,
                                      enterpriseOriginCode:
                                          enterpriseOriginCode,
                                      enterpriseDestinyCode:
                                          enterpriseDestinyCode,
                                      requestTypeCode: requestTypeCode,
                                    );
                                    updateSelectedIndex();

                                    ShowSnackbarMessage.show(
                                      message: "Produto removido",
                                      context: context,
                                      functionSnackBarAction: () {
                                        transferRequestProvider
                                            .restoreProductRemoved(
                                          ProductPackingCode:
                                              product.ProductPackingCode,
                                          enterpriseOriginCode:
                                              enterpriseOriginCode,
                                          enterpriseDestinyCode:
                                              enterpriseDestinyCode,
                                          requestTypeCode: requestTypeCode,
                                        );
                                      },
                                      labelSnackBarAction: "Restaurar produto",
                                    );
                                  },
                                );
                              },
                        icon: Icon(
                          Icons.delete,
                          color: transferRequestProvider
                                  .isLoadingSaveTransferRequest
                              ? Colors.grey
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _titleAndSubtitle(
                              flex: 20,
                              title: "Qtd",
                              subtitle: product.Quantity.toStringAsFixed(3)
                                  .replaceAll(RegExp(r'\.'), ','),
                            ),
                            _titleAndSubtitle(
                              flex: 20,
                              title: "Preço",
                              subtitle: ConvertString.convertToBRL(
                                product.Value.toString(),
                              ),
                            ),
                            const SizedBox(width: 5),
                            _titleAndSubtitle(
                              flex: 30,
                              title: "Total",
                              subtitle: ConvertString.convertToBRL(
                                "${(product.Quantity * product.Value) - product.DiscountValue} ",
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed:
                            transferRequestProvider.isLoadingSaveTransferRequest
                                ? null
                                : () {
                                    changeFocus();
                                  },
                        icon: selectedIndex != -1
                            ? Icon(
                                Icons.expand_less,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : Icon(
                                Icons.edit,
                                color: transferRequestProvider
                                        .isLoadingSaveTransferRequest
                                    ? Colors.grey
                                    : Theme.of(context).colorScheme.primary,
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
