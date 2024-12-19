import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../models/enterprise/enterprise.dart';
import '../../../../models/soap/soap.dart';
import '../../../../providers/providers.dart';
import 'filter.dart';

class FilterSupplier extends StatelessWidget {
  final FocusNode searchSupplierFocusNode;
  final TextEditingController searchSupplierController;
  final EnterpriseModel enterprise;
  const FilterSupplier({
    required this.searchSupplierFocusNode,
    required this.searchSupplierController,
    required this.enterprise,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    BuyQuotationProvider buyQuotationProvider = Provider.of(context);

    return SearchItemToFilter(
      focusNode: searchSupplierFocusNode,
      controller: searchSupplierController,
      enterprise: enterprise,
      labelSearch: "Filtrar fornecedor",
      showConfigurationsIcon: false,
      items: buyQuotationProvider.searchedSuppliers,
      hintSearch: "Nome-CNPJ-Código",
      updateSelectedItem: (SupplierModel supplier) {
        buyQuotationProvider.updateSelectedSupplier(supplier);
      },
      searchItems: () async {
        await buyQuotationProvider.searchSupplier(
          context: context,
          searchController: searchSupplierController,
        );
      },
      itemWidgetToSelect: (SupplierModel supplier) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TitleAndSubtitle.titleAndSubtitle(
                  subtitle: supplier.Name,
                ),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "CNPJ",
                  subtitle: supplier.CnpjCpfNumber,
                ),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Código",
                  subtitle: supplier.Code.toString(),
                ),
                if (buyQuotationProvider.selectedSupplier != null)
                  TextButton.icon(
                    onPressed: () {
                      buyQuotationProvider.updateSelectedSupplier(null);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    label: const Text(
                      "Remover filtro do fornecedor",
                      style: TextStyle(color: Colors.red),
                    ),
                  )
              ],
            ),
          ),
        );
      },
      selectedItem: buyQuotationProvider.selectedSupplier,
    );
  }
}
