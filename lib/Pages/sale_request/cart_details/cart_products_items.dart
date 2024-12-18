import 'package:flutter/material.dart';

import '../../../models/soap/soap.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';
import '../../../components/components.dart';

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

  static Widget saleRequestCartProductsItems({
    required SaleRequestProvider saleRequestProvider,
    required dynamic changeFocus,
    required BuildContext context,
    required int index,
    required GetProductJsonModel product,
    required int enterpriseCode,
    required int selectedIndex,
    required Function updateSelectedIndex,
  }) {
    return GestureDetector(
      onTap: saleRequestProvider.isLoadingSaveSaleRequest ||
              saleRequestProvider.isLoadingProcessCart
          ? null
          : () async {
              await changeFocus();
            },
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
                          product.name! +
                              " (${product.packingQuantity})" +
                              '\nplu: ${product.plu}',
                          style: const TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: saleRequestProvider
                                    .isLoadingSaveSaleRequest ||
                                saleRequestProvider.isLoadingProcessCart
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
                                    saleRequestProvider.removeProductFromCart(
                                      ProductPackingCode:
                                          product.productPackingCode!,
                                      enterpriseCode: enterpriseCode.toString(),
                                    );
                                    if (selectedIndex == index) {
                                      updateSelectedIndex();
                                    }

                                    ShowSnackbarMessage.show(
                                      message: "Produto removido",
                                      context: context,
                                      functionSnackBarAction: () {
                                        saleRequestProvider
                                            .restoreProductRemoved(
                                                enterpriseCode.toString());
                                      },
                                      labelSnackBarAction: "Restaurar produto",
                                    );
                                  },
                                );
                              },
                        icon: Icon(
                          Icons.delete,
                          color: saleRequestProvider.isLoadingSaveSaleRequest ||
                                  saleRequestProvider.isLoadingProcessCart
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
                              subtitle: product.quantity
                                  .toStringAsFixed(3)
                                  .replaceAll(RegExp(r'\.'), ','),
                            ),
                            _titleAndSubtitle(
                              flex: 20,
                              title: "Preço",
                              subtitle: ConvertString.convertToBRL(
                                product.value.toString(),
                              ),
                            ),
                            const SizedBox(width: 5),
                            _titleAndSubtitle(
                              flex: 30,
                              title: "Total",
                              subtitle: ConvertString.convertToBRL(
                                product.value! * product.quantity,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed:
                            saleRequestProvider.isLoadingSaveSaleRequest ||
                                    saleRequestProvider.isLoadingProcessCart
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
                                color: saleRequestProvider
                                            .isLoadingSaveSaleRequest ||
                                        saleRequestProvider.isLoadingProcessCart
                                    ? Colors.grey
                                    : Theme.of(context).colorScheme.primary,
                              ),
                      ),
                    ],
                  ),
                  if (product.AutomaticDiscountValue != null &&
                      product.AutomaticDiscountValue! > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Column(
                        children: [
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Desconto",
                            subtitleColor:
                                Theme.of(context).colorScheme.primary,
                            subtitle: ConvertString.convertToBRL(
                              product.AutomaticDiscountValue,
                            ),
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            subtitleColor:
                                Theme.of(context).colorScheme.primary,
                            subtitle: saleRequestProvider
                                .getDiscountDescription(product),
                          ),
                        ],
                      ),
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
