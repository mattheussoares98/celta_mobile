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
          searchProductFocusNode: FocusNode(),
          searchProductController: searchProductsController,
          isLoading: expeditionConferenceProvider.isLoading,
          onPressSearch: () async {
            await expeditionConferenceProvider.getProducts(
              value: searchProductsController.text,
              enterpriseCode: enterprise.codigoInternoEmpresa,
              configurationsProvider: ConfigurationsProvider(),
            );

            if (expeditionConferenceProvider.searchedProducts.length == 1) {
              final succeeds =
                  expeditionConferenceProvider.addConfirmedProduct(0);
              if (succeeds) {
                ShowSnackbarMessage.showMessage(
                  message: "Produto confirmado",
                  context: context,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                );
              } else {
                ShowSnackbarMessage.showMessage(
                  message: expeditionConferenceProvider.errorMessageGetProducts,
                  context: context,
                );
              }
            } else {
              showDialog(
                context: context,
                builder: (context) => const ConfirmProductDialog(),
              );
            }
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
