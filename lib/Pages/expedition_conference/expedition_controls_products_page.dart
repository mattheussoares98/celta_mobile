import 'package:celta_inventario/components/components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';

class ExpeditionControlsProductsPage extends StatelessWidget {
  const ExpeditionControlsProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    ExpeditionConferenceProvider expeditionConferenceProvider =
        Provider.of(context);

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
                      //TODO
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
