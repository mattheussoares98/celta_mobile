import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../models/configurations/configurations.dart';
import '../../../models/enterprise/enterprise_model.dart';
import '../adjust_sale_price.dart';
import '../../../providers/providers.dart';

class AdjustSalePriceProductsPage extends StatefulWidget {
  const AdjustSalePriceProductsPage({super.key});

  @override
  State<AdjustSalePriceProductsPage> createState() =>
      _AdjustSalePriceProductsPageState();
}

class _AdjustSalePriceProductsPageState
    extends State<AdjustSalePriceProductsPage> {
  final searchValueController = TextEditingController();
  final searchFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    searchFocusNode.dispose();
    searchValueController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AdjustSalePriceProvider adjustSalePriceProvider = Provider.of(context);
    ConfigurationsProvider configurationsProvider = Provider.of(context);
    EnterpriseModel enterprise =
        ModalRoute.of(context)!.settings.arguments as EnterpriseModel;

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: PopScope(
        canPop: !adjustSalePriceProvider.isLoading,
        onPopInvokedWithResult: (_, __) {
          adjustSalePriceProvider.clearDataOnCloseProductsScreen();
        },
        child: Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: const Text("Produtos"),
              ),
              body: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SearchWidget(
                    searchFocusNode: searchFocusNode,
                    configurations: [
                      ConfigurationType.legacyCode,
                      ConfigurationType.personalizedCode,
                    ],
                    searchProductController: searchValueController,
                    onPressSearch: () async {
                      await adjustSalePriceProvider.getProducts(
                        enterprise: enterprise,
                        searchValue: searchValueController.text,
                        configurationsProvider: configurationsProvider,
                      );

                      if (adjustSalePriceProvider.products.isNotEmpty) {
                        searchValueController.clear();
                      }
                    },
                  ),
                  if (adjustSalePriceProvider.errorMessage != "" &&
                      adjustSalePriceProvider.products.length == 0)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ErrorMessage(
                            errorMessage: adjustSalePriceProvider.errorMessage),
                      ),
                    ),
                  if (!adjustSalePriceProvider.isLoading &&
                      adjustSalePriceProvider.products.isNotEmpty)
                    const ProductsItems(),
                  // if (MediaQuery.of(context).viewInsets.bottom == 0 &&
                  //     priceConferenceProvider.productsCount > 1)
                  //   //só mostra a opção de organizar se houver mais de um produto e se o teclado estiver fechado
                  //   PriceConferenceOrderProductsButtons(
                  //       priceConferenceProvider: priceConferenceProvider)
                ],
              ),
            ),
            loadingWidget(adjustSalePriceProvider.isLoading),
          ],
        ),
      ),
    );
  }
}
