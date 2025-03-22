import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';

import '../../../../Models/models.dart';
import '../../../../providers/providers.dart';

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

    return Column(
      children: [
        SearchWidget(
          labelText: "Filtrar fornecedor",
          searchFocusNode: searchSupplierFocusNode,
          configurations: [],
          showConfigurationsIcon: false,
          searchProductController: searchSupplierController,
          hintText: "Filtrar fornecedor",
          onPressSearch: () async {
            await buyQuotationProvider.searchSupplier(
              context: context,
              searchController: searchSupplierController,
            );

            final searchedSuppliers = buyQuotationProvider.searchedSuppliers;
            if (searchedSuppliers.isNotEmpty) {
              searchSupplierController.clear();
            }

            if (searchedSuppliers.length > 1) {
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
                    itemCount: searchedSuppliers.length,
                    itemBuilder: (context, index) {
                      final supplier = searchedSuppliers[index];

                      return InkWell(
                        onTap: () {
                          buyQuotationProvider.updateSelectedSupplier(supplier);

                          Navigator.of(context).pop();
                        },
                        child: supplierItem(
                          supplier: supplier,
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
        supplierItem(
          supplier: buyQuotationProvider.selectedSupplier,
          buyQuotationProvider: buyQuotationProvider,
          showRemoveFilter: true,
        )
      ],
    );
  }
}

Widget supplierItem({
  required SupplierModel? supplier,
  required BuyQuotationProvider buyQuotationProvider,
  required bool showRemoveFilter,
}) =>
    supplier == null
        ? const SizedBox()
        : Card(
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
                  if (showRemoveFilter)
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
                    ),
                ],
              ),
            ),
          );
