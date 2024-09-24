import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
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
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        ExpeditionConferenceProvider expeditionConferenceProvider =
            Provider.of(context, listen: false);
        ExpeditionControlModel expeditionControl = ModalRoute.of(context)!
            .settings
            .arguments as ExpeditionControlModel;

        await expeditionConferenceProvider.getProducts(
          expeditionControlCode: expeditionControl.ExpeditionControlCode!,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ExpeditionConferenceProvider expeditionConferenceProvider =
        Provider.of(context);
    ExpeditionControlModel expeditionControl =
        ModalRoute.of(context)!.settings.arguments as ExpeditionControlModel;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const FittedBox(child: Text("Conferência de produtos")),
            actions: [
              IconButton(
                onPressed: () async {
                  await expeditionConferenceProvider.getProducts(
                    expeditionControlCode:
                        expeditionControl.ExpeditionControlCode!,
                  );
                },
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: expeditionConferenceProvider.pendingProducts.length,
            itemBuilder: (context, index) {
              ExpeditionControlProductModel product =
                  expeditionConferenceProvider.pendingProducts[index];

              return ExpeditionControlProductItem(product: product);
            },
          ),
        ),
        loadingWidget(
          message: "Aguarde...",
          isLoading: expeditionConferenceProvider.isLoading,
        ),
      ],
    );
  }
}
