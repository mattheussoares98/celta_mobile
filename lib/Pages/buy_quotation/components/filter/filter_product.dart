import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../models/enterprise/enterprise.dart';
import '../../../../models/soap/products/products.dart';
import '../../../../providers/providers.dart';
import 'filter.dart';

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

    return SearchItemToFilter(
      focusNode: searchProductFocusNode,
      controller: searchProductController,
      enterprise: enterprise,
      items: buyQuotationProvider.searchedProducts,
      labelSearch: "Filtrar produto",
      selectedItem: buyQuotationProvider.selectedProduct,
      showConfigurationsIcon: true,
      updateSelectedItem: (GetProductJsonModel item) {
        buyQuotationProvider.updateSelectedProduct(item);
      },
      searchItems: () async {
        buyQuotationProvider.searchProduct(
          enterprise: enterprise,
          searchProductController: searchProductController,
          configurationsProvider: configurationsProvider,
          context: context,
        );
      },
      itemWidgetToSelect: (GetProductJsonModel item) => Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TitleAndSubtitle.titleAndSubtitle(
                subtitle: "${item.name} (${item.packingQuantity})",
              ),
              TitleAndSubtitle.titleAndSubtitle(
                  title: "PLU",
                  subtitle: item.plu,
                  otherWidget: buyQuotationProvider.selectedProduct == null
                      ? null
                      : TextButton.icon(
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
                        )),
            ],
          ),
        ),
      ),
    );
  }
}
