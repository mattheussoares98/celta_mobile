import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../models/models.dart';
import '../../../providers/providers.dart';

class ProductInformations extends StatelessWidget {
  final int index;
  final GetProductJsonModel product;
  final int enterpriseCode;
  final int selectedIndex;

  const ProductInformations({
    required this.index,
    required this.product,
    required this.enterpriseCode,
    required this.selectedIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider = Provider.of(context);

    return Row(
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
                    onPressed: saleRequestProvider.isLoadingSaveSaleRequest ||
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

                                ShowSnackbarMessage.show(
                                  message: "Produto removido",
                                  context: context,
                                  functionSnackBarAction: () {
                                    saleRequestProvider.restoreProductRemoved(
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
            ],
          ),
        ),
      ],
    );
  }
}
