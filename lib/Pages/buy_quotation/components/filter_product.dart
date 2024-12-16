import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../models/configurations/configurations.dart';
import '../../../models/enterprise/enterprise.dart';
import '../../../providers/providers.dart';

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
          configurations: [
            ConfigurationType.legacyCode,
            ConfigurationType.personalizedCode,
          ],
          searchProductController: searchProductController,
          onPressSearch: () async {
            await buyQuotationProvider.searchProduct(
              enterprise: enterprise,
              searchProductController: searchProductController,
              configurationsProvider: configurationsProvider,
              context: context,
            );

            if (buyQuotationProvider.searchedProducts.length > 1) {
              ShowAlertDialog.show(
                  context: context,
                  title: "Selecione um produto",
                  insetPadding: const EdgeInsets.symmetric(vertical: 8),
                  contentPadding: const EdgeInsets.all(0),
                  showConfirmAndCancelMessage: false,
                  showCloseAlertDialogButton: true,
                  canCloseClickingOut: false,
                  content: Scaffold(
                    body: ListView.builder(
                      shrinkWrap: true,
                      itemCount: buyQuotationProvider.searchedProducts.length,
                      itemBuilder: (context, index) {
                        final product =
                            buyQuotationProvider.searchedProducts[index];

                        return InkWell(
                          onTap: () {
                            buyQuotationProvider.updateSelectedProduct(product);
                            Navigator.of(context).pop();
                          },
                          child: Card(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                TitleAndSubtitle.titleAndSubtitle(
                                  subtitle:
                                      "${product.name} (${product.packingQuantity})",
                                ),
                                TitleAndSubtitle.titleAndSubtitle(
                                  title: "PLU",
                                  subtitle: product.plu,
                                ),
                              ],
                            ),
                          )),
                        );
                      },
                    ),
                  ),
                  function: () async {
                    // buyQuotationProvider
                    //     .updateFilteredProduct(product);
                  });
            }
          },
          searchFocusNode: searchProductFocusNode,
        ),
        if (buyQuotationProvider.selectedProduct != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TitleAndSubtitle.titleAndSubtitle(
                    subtitle:
                        "${buyQuotationProvider.selectedProduct!.name} (${buyQuotationProvider.selectedProduct!.packingQuantity})",
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "PLU",
                    subtitle: buyQuotationProvider.selectedProduct!.plu,
                    otherWidget: TextButton.icon(
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
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
