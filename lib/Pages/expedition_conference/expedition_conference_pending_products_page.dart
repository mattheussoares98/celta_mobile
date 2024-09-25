import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../models/enterprise/enterprise.dart';
import '../../models/expedition_control/expedition_control.dart';
import '../../providers/providers.dart';
import 'components/components.dart';

class ExpeditionConferencePendingProductsPage extends StatefulWidget {
  const ExpeditionConferencePendingProductsPage({super.key});

  @override
  State<ExpeditionConferencePendingProductsPage> createState() =>
      _ExpeditionConferencePendingProductsPageState();
}

class _ExpeditionConferencePendingProductsPageState
    extends State<ExpeditionConferencePendingProductsPage> {
  final searchProductsController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    searchProductsController.dispose();
  }

  Future<void> searchProduct(
    ExpeditionConferenceProvider expeditionConferenceProvider,
    EnterpriseModel enterprise,
  ) async {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    ExpeditionControlModel expeditionControl = arguments["expeditionControl"];

    await expeditionConferenceProvider.getProducts(
      value: searchProductsController.text,
      enterpriseCode: enterprise.codigoInternoEmpresa,
      configurationsProvider: ConfigurationsProvider(),
    );

    if (expeditionConferenceProvider.searchedProducts.isEmpty) {
      return;
    } else if (expeditionConferenceProvider.searchedProducts.length == 1) {
      await expeditionConferenceProvider.addConfirmedProduct(
        indexOfSearchedProduct: 0,
        expeditionControlCode: expeditionControl.ExpeditionControlCode!,
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => ConfirmProductDialog(
          expeditionControlCode: expeditionControl.ExpeditionControlCode!,
        ),
      );
    }
    searchProductsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    ExpeditionConferenceProvider expeditionConferenceProvider =
        Provider.of(context);
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final expeditionControl =
        arguments["expeditionControl"] as ExpeditionControlModel;
    final enterprise = arguments["enterprise"] as EnterpriseModel;

    if (expeditionConferenceProvider.errorMessage != "" &&
        expeditionConferenceProvider.pendingProducts.isEmpty) {
      return searchAgain(
          errorMessage: expeditionConferenceProvider.errorMessage,
          request: () async {
            await expeditionConferenceProvider.getPendingProducts(
              expeditionControlCode: expeditionControl.ExpeditionControlCode!,
            );
          });
    }

    return Column(
      children: [
        SearchWidget(
          useCamera: true,
          autofocus: true,
          showOnlyConfigurationOfSearchProducts: true,
          searchProductFocusNode: FocusNode(),
          searchProductController: searchProductsController,
          isLoading: expeditionConferenceProvider.isLoading,
          onPressSearch: expeditionConferenceProvider.pendingProducts.isEmpty
              ? null
              : () async {
                  await searchProduct(expeditionConferenceProvider, enterprise);
                },
        ),
        Expanded(
          child: ListView.builder(
            itemCount: expeditionConferenceProvider.pendingProducts.length,
            itemBuilder: (context, index) {
              ExpeditionControlProductModel product =
                  expeditionConferenceProvider.pendingProducts[index];

              return ExpeditionControlProductItem(product: product);
            },
          ),
        ),
      ],
    );
  }
}
