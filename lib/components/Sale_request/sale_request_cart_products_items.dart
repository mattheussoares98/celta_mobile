import 'package:celta_inventario/Components/Global_widgets/show_alert_dialog.dart';
import 'package:celta_inventario/Models/sale_request_models/sale_request_cart_products_model.dart';
import 'package:celta_inventario/components/Global_widgets/show_snackbar_message.dart';
import 'package:celta_inventario/components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:flutter/material.dart';

import '../../utils/convert_string.dart';

class SaleRequestCartProductsItems {
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
    required SaleRequestCartProductsModel product,
    required int enterpriseCode,
    required int selectedIndex,
    required Function updateSelectedIndex,
  }) {
    return InkWell(
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
                        onPressed: saleRequestProvider
                                    .isLoadingSaveSaleRequest ||
                                saleRequestProvider.isLoadingProcessCart
                            ? null
                            : () {
                                ShowAlertDialog.showAlertDialog(
                                  context: context,
                                  title: "Remover item",
                                  subtitle:
                                      "Deseja realmente remover o item do carrinho?",
                                  function: () {
                                    saleRequestProvider.removeProductFromCart(
                                      ProductPackingCode:
                                          product.ProductPackingCode,
                                      enterpriseCode: enterpriseCode.toString(),
                                    );
                                    if (selectedIndex == index) {
                                      updateSelectedIndex();
                                    }

                                    ShowSnackbarMessage.showMessage(
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
                                saleRequestProvider.getTotalItemPrice(product),
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
                  if (product.AutomaticDiscountValue > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Column(
                        children: [
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Desconto",
                            subtitleColor:
                                Theme.of(context).colorScheme.primary,
                            value: ConvertString.convertToBRL(
                              product.AutomaticDiscountValue,
                            ),
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            subtitleColor:
                                Theme.of(context).colorScheme.primary,
                            value: saleRequestProvider
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
