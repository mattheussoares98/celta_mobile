import 'package:celta_inventario/components/components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/expedition_control/expedition_control.dart';
import '../../providers/providers.dart';

class ExpeditionControlsProductsPage extends StatefulWidget {
  const ExpeditionControlsProductsPage({super.key});

  @override
  State<ExpeditionControlsProductsPage> createState() =>
      _ExpeditionControlsProductsPageState();
}

class _ExpeditionControlsProductsPageState
    extends State<ExpeditionControlsProductsPage> {
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

    return PopScope(
      onPopInvokedWithResult: (_, __) {
        //TODO
      },
      child: Stack(
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
                    icon: const Icon(Icons.refresh))
              ],
            ),
            body: const Center(
              child: Text("Conferência de produtos"),
            ),
          ),
          loadingWidget(
            message: "Aguarde...",
            isLoading: expeditionConferenceProvider.isLoading,
          ),
        ],
      ),
    );
  }
}
