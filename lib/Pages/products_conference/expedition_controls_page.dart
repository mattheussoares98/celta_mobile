import 'package:celta_inventario/components/components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/enterprise/enterprise.dart';
import '../../providers/providers.dart';

class ExpeditionControlsPage extends StatefulWidget {
  const ExpeditionControlsPage({super.key});

  @override
  State<ExpeditionControlsPage> createState() => _ExpeditionControlsPageState();
}

class _ExpeditionControlsPageState extends State<ExpeditionControlsPage> {
  Future<void> _getExpeditionControlsToConference() async {
    await Future.delayed(Duration.zero);

    ProductsConferenceProvider productsConferenceProvider =
        Provider.of(context, listen: false);

    EnterpriseModel enterprise =
        ModalRoute.of(context)!.settings.arguments as EnterpriseModel;

    await productsConferenceProvider.getExpeditionControlsToConference(
      enterpriseCode: enterprise.codigoInternoEmpresa,
    );
  }

  @override
  void initState() {
    super.initState();

    _getExpeditionControlsToConference();
  }

  @override
  Widget build(BuildContext context) {
    ProductsConferenceProvider productsConferenceProvider =
        Provider.of(context);
    EnterpriseModel enterprise =
        ModalRoute.of(context)!.settings.arguments as EnterpriseModel;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text("Controles de expedição"),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (productsConferenceProvider.errorMessage != "")
                  searchAgain(
                      errorMessage: productsConferenceProvider.errorMessage,
                      request: () async {
                        await productsConferenceProvider
                            .getExpeditionControlsToConference(
                          enterpriseCode: enterprise.codigoInternoEmpresa,
                        );
                      }),
              ],
            ),
          ),
        ),
        loadingWidget(
          message: "Aguarde...",
          isLoading: productsConferenceProvider.isLoading,
        )
      ],
    );
  }
}
