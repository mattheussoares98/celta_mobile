import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../models/models.dart';
import '../../../../providers/providers.dart';

class FilterProduct extends StatelessWidget {
  final FocusNode searchProductFocusNode;
  final TextEditingController searchProductController;
  final EnterpriseModel enterprise;
  const FilterProduct({
    required this.searchProductFocusNode,
    required this.searchProductController,
    required this.enterprise,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    BuyQuotationProvider buyQuotationProvider = Provider.of(context);
    ConfigurationsProvider configurationsProvider = Provider.of(context);

    return Column(
      children: [
        SearchWidget(
          labelText: "Filtrar produto",
          searchFocusNode: searchProductFocusNode,
          configurations: [
            ConfigurationType.legacyCode,
            ConfigurationType.personalizedCode,
          ],
          showConfigurationsIcon: true,
          searchProductController: searchProductController,
          onPressSearch: () async {
            await buyQuotationProvider.searchProduct(
              enterprise: enterprise,
              searchProductController: searchProductController,
              configurationsProvider: configurationsProvider,
              context: context,
            );

            final searchedProducts = buyQuotationProvider.searchedProducts;
            if (searchedProducts.isNotEmpty) {
              searchProductController.clear();
            }

            if (searchedProducts.length > 1) {
              ShowAlertDialog.show(
                context: context,
                title: "Selecione um item",
                insetPadding: const EdgeInsets.symmetric(vertical: 8),
                contentPadding: const EdgeInsets.all(0),
                showConfirmAndCancelMessage: false,
                showCloseAlertDialogButton: true,
                canCloseClickingOut: false,
                content: Scaffold(
                  body: ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchedProducts.length,
                    itemBuilder: (context, index) {
                      final product = searchedProducts[index];

                      return InkWell(
                        onTap: () {
                          buyQuotationProvider.updateSelectedProduct(product);

                          Navigator.of(context).pop();
                        },
                        child: productItem(
                          product: product,
                          buyQuotationProvider: buyQuotationProvider,
                          showRemoveFilter: false,
                        ),
                      );
                    },
                  ),
                ),
                function: () async {},
              );
            }
          },
        ),
        productItem(
          product: buyQuotationProvider.selectedProduct,
          buyQuotationProvider: buyQuotationProvider,
          showRemoveFilter: true,
        )
      ],
    );
  }
}

Widget productItem({
  required GetProductJsonModel? product,
  required BuyQuotationProvider buyQuotationProvider,
  required bool showRemoveFilter,
}) =>
    product == null
        ? const SizedBox()
        : Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TitleAndSubtitle.titleAndSubtitle(
                    subtitle: "${product.name} (${product.packingQuantity})",
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "PLU",
                    subtitle: product.plu,
                  ),
                  if (showRemoveFilter)
                    TextButton.icon(
                      onPressed: () {
                        buyQuotationProvider.updateSelectedProduct(null);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      label: const Text(
                        "Remover filtro do produto",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          );
