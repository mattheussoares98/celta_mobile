import 'package:celta_inventario/components/components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  @override
  Widget build(BuildContext context) {
    ExpeditionConferenceProvider expeditionConferenceProvider =
        Provider.of(context);
    ExpeditionControlModel expeditionControl =
        ModalRoute.of(context)!.settings.arguments as ExpeditionControlModel;

    if (expeditionConferenceProvider.errorMessage != "" &&
        expeditionConferenceProvider.pendingProducts.isEmpty) {
      return searchAgain(
          errorMessage: expeditionConferenceProvider.errorMessage,
          request: () async {
            await expeditionConferenceProvider.getProducts(
              expeditionControlCode: expeditionControl.ExpeditionControlCode!,
            );
          });
    }

    return ListView.builder(
      itemCount: expeditionConferenceProvider.pendingProducts.length,
      itemBuilder: (context, index) {
        ExpeditionControlProductModel product =
            expeditionConferenceProvider.pendingProducts[index];

        return ExpeditionControlProductItem(product: product);
      },
    );
  }
}
