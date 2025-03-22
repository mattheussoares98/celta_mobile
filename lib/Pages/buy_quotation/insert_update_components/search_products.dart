import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../Models/models.dart';
import '../../../providers/providers.dart';

class SearchProducts extends StatelessWidget {
  final TextEditingController searchProductController;
  final EnterpriseModel enterprise;
  final FocusNode searchFocusNode;
  final void Function() cleanSelectedIndex;
  const SearchProducts({
    required this.searchProductController,
    required this.enterprise,
    required this.searchFocusNode,
    required this.cleanSelectedIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    BuyQuotationProvider buyQuotationProvider = Provider.of(context);
    ConfigurationsProvider configurationsProvider = Provider.of(context);

    return SearchWidget(
      configurations: [
        ConfigurationType.legacyCode,
        ConfigurationType.personalizedCode,
      ],
      labelText: "Adicionar produto",
      searchProductController: searchProductController,
      autofocus: false,
      onPressSearch: () async {
        cleanSelectedIndex();
        await buyQuotationProvider.searchProductsToAdd(
          enterprise: enterprise,
          searchProductController: searchProductController,
          configurationsProvider: configurationsProvider,
          context: context,
        );

        if (buyQuotationProvider.searchedProductsToAdd.length > 1) {
          ShowAlertDialog.show(
            context: context,
            title: "Selecione os produtos",
            contentPadding: const EdgeInsets.all(3),
            insetPadding: const EdgeInsets.all(3),
            canCloseClickingOut: false,
            cancelMessage: "Cancelar",
            confirmMessage: "Adicionar",
            function: () {
              buyQuotationProvider.insertNewProductInProductsWithNewValues(
                enterprise: enterprise,
                configurationsProvider: configurationsProvider,
                products: buyQuotationProvider.selectedsProductsToAdd,
              );
            },
            content: Scaffold(
              body: ListView.builder(
                itemCount: buyQuotationProvider.searchedProductsToAdd.length,
                itemBuilder: (context, index) {
                  final product =
                      buyQuotationProvider.searchedProductsToAdd[index];

                  return StatefulBuilder(
                    builder: (context, setState) => Card(
                        child: InkWell(
                      onTap: () {
                        setState(() {
                          buyQuotationProvider
                              .addOrRemoveSelectedProduct(product);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
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
                            ),
                            Checkbox(
                              value: buyQuotationProvider.selectedsProductsToAdd
                                  .contains(product),
                              onChanged: (_) {
                                setState(() {
                                  buyQuotationProvider
                                      .addOrRemoveSelectedProduct(product);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    )),
                  );
                },
              ),
            ),
          );
        }
      },
      searchFocusNode: searchFocusNode,
    );
  }
}
