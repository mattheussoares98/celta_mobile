import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../models/models.dart';
import '../../../providers/providers.dart';

class SearchProducts extends StatelessWidget {
  final TextEditingController searchProductController;
  final EnterpriseModel enterprise;
  final FocusNode searchFocusNode;
  const SearchProducts({
    required this.searchProductController,
    required this.enterprise,
    required this.searchFocusNode,
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
      onPressSearch: () async {
        await buyQuotationProvider.searchProductsToAdd(
          enterprise: enterprise,
          searchProductController: searchProductController,
          configurationsProvider: configurationsProvider,
          context: context,
        );

        if (buyQuotationProvider.searchedProductsToAdd.length > 1 &&
            buyQuotationProvider.productToAdd == null) {
          ShowAlertDialog.show(
            context: context,
            title: "Selecione um produto",
            contentPadding: const EdgeInsets.all(3),
            insetPadding: const EdgeInsets.all(3),
            showConfirmAndCancelMessage: false,
            canCloseClickingOut: false,
            showCloseAlertDialogButton: true,
            content: Scaffold(
              body: ListView.builder(
                itemCount: buyQuotationProvider.searchedProductsToAdd.length,
                itemBuilder: (context, index) {
                  final product =
                      buyQuotationProvider.searchedProductsToAdd[index];

                  return InkWell(
                    onTap: () async {
                      Navigator.of(context).pop();
                      await buyQuotationProvider.getEnterprisesCodesByAProduct(
                        plu: product.plu!,
                        enterprise: enterprise,
                        configurationsProvider: configurationsProvider,
                      );
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
            function: () async {},
          );
        }
      },
      searchFocusNode: searchFocusNode,
    );
  }
}
