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
  final searchProductFocusNode = FocusNode();
  bool disposedProductsController = false;

  @override
  void dispose() {
    super.dispose();
    disposedProductsController = true;
    searchProductsController.dispose();
    searchProductFocusNode.dispose();
  }

  Future<void> searchProduct(
    ExpeditionConferenceProvider expeditionConferenceProvider,
    EnterpriseModel enterprise,
  ) async {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    ExpeditionControlModel expeditionControl = arguments["expeditionControl"];
    EnterpriseModel enterprise = arguments["enterprise"];

    await expeditionConferenceProvider.getProducts(
      value: searchProductsController.text,
      enterprise: enterprise,
      configurationsProvider: ConfigurationsProvider(),
      expeditionControlCode: expeditionControl.ExpeditionControlCode!,
      stepCode: expeditionControl.StepCode!,
    );

    if (expeditionConferenceProvider.errorMessageGetProducts.isEmpty &&
        !disposedProductsController) {
      searchProductsController.clear();
    }

    if (expeditionConferenceProvider.searchedProducts.length > 1) {
      await showDialog(
        context: context,
        builder: (context) => ConfirmProductDialog(
          expeditionControlCode: expeditionControl.ExpeditionControlCode!,
          enterprise: enterprise,
          stepCode: expeditionControl.StepCode!,
        ),
      );
    }

    if (expeditionConferenceProvider.pendingProducts.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 100), () {
        FocusScope.of(context).requestFocus(searchProductFocusNode);
      });
    }
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
          searchFocusNode: searchProductFocusNode,
          searchProductController: searchProductsController,
          onPressSearch: expeditionConferenceProvider.pendingProducts.isEmpty
              ? null
              : () async {
                  await searchProduct(expeditionConferenceProvider, enterprise);
                },
        ),
        if (expeditionConferenceProvider
            .errorMessageConfirmConference.isNotEmpty)
          searchAgain(
            message: "Tentar confirmar conferência novamente",
            errorMessage:
                expeditionConferenceProvider.errorMessageConfirmConference,
            request: () async {
              await expeditionConferenceProvider.confirmConference(
                expeditionControlCode: expeditionControl.ExpeditionControlCode!,
                enterprise: enterprise,
                stepCode: expeditionControl.StepCode!,
              );
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
