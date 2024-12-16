import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../models/configurations/configurations.dart';
import '../../../models/enterprise/enterprise.dart';
import '../../../models/soap/soap.dart';
import '../../../providers/providers.dart';

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
          hintText: "Código-Nome-CNPJ",
          labelText: "Filtrar fornecedor",
          configurations: [
            ConfigurationType.legacyCode,
            ConfigurationType.personalizedCode,
          ],
          searchProductController: searchSupplierController,
          onPressSearch: () async {
            await buyQuotationProvider.getSupplier(
              context: context,
              searchController: searchSupplierController,
            );

            if (buyQuotationProvider.searchedSuppliers.length > 1) {
              ShowAlertDialog.show(
                  context: context,
                  title: "Selecione um fornecedor",
                  insetPadding: const EdgeInsets.symmetric(vertical: 8),
                  contentPadding: const EdgeInsets.all(0),
                  showConfirmAndCancelMessage: false,
                  showCloseAlertDialogButton: true,
                  canCloseClickingOut: false,
                  content: Scaffold(
                    body: ListView.builder(
                      shrinkWrap: true,
                      itemCount: buyQuotationProvider.searchedSuppliers.length,
                      itemBuilder: (context, index) {
                        final supplier =
                            buyQuotationProvider.searchedSuppliers[index];

                        return InkWell(
                          onTap: () {
                            buyQuotationProvider
                                .updateSelectedSupplier(supplier);
                            Navigator.of(context).pop();
                          },
                          child: Card(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: supplierWidget(supplier, null),
                          )),
                        );
                      },
                    ),
                  ),
                  function: () async {});
            }
          },
          searchFocusNode: searchSupplierFocusNode,
        ),
        if (buyQuotationProvider.selectedSupplier != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: supplierWidget(
                buyQuotationProvider.selectedSupplier!,
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
              ),
            ),
          ),
      ],
    );
  }
}

Widget supplierWidget(
  SupplierModel supplier,
  Widget? otherWidget,
) =>
    Column(
      children: [
        TitleAndSubtitle.titleAndSubtitle(
          subtitle: supplier.Name,
          otherWidget: otherWidget,
        ),
        TitleAndSubtitle.titleAndSubtitle(
          title: "CNPJ",
          subtitle: supplier.CnpjCpfNumber,
        ),
        TitleAndSubtitle.titleAndSubtitle(
          title: "Código",
          subtitle: supplier.Code.toString(),
        ),
      ],
    );
