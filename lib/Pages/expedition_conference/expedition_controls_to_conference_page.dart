import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../models/enterprise/enterprise.dart';
import '../../pages/expedition_conference/components/components.dart';
import '../../providers/providers.dart';

class ExpeditionControlsToConferencePage extends StatefulWidget {
  const ExpeditionControlsToConferencePage({super.key});

  @override
  State<ExpeditionControlsToConferencePage> createState() =>
      _ExpeditionControlsToConferencePageState();
}

class _ExpeditionControlsToConferencePageState
    extends State<ExpeditionControlsToConferencePage> {
  Future<void> _getExpeditionControlsToConference() async {
    await Future.delayed(Duration.zero);

    ExpeditionConferenceProvider expeditionConferenceProvider =
        Provider.of(context, listen: false);

    EnterpriseModel enterprise =
        ModalRoute.of(context)!.settings.arguments as EnterpriseModel;

    await expeditionConferenceProvider.getExpeditionControlsToConference(
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
    ExpeditionConferenceProvider expeditionConferenceProvider =
        Provider.of(context);
    EnterpriseModel enterprise =
        ModalRoute.of(context)!.settings.arguments as EnterpriseModel;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text("Controles de expedição"),
            actions: [
              IconButton(
                onPressed: () async {
                  await expeditionConferenceProvider
                      .getExpeditionControlsToConference(
                          enterpriseCode: enterprise.codigoInternoEmpresa);
                },
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (expeditionConferenceProvider.errorMessage != "")
                  searchAgain(
                      errorMessage: expeditionConferenceProvider.errorMessage,
                      request: () async {
                        await expeditionConferenceProvider
                            .getExpeditionControlsToConference(
                          enterpriseCode: enterprise.codigoInternoEmpresa,
                        );
                      }),
                const ExpeditionControlsToConferenceItems(),
              ],
            ),
          ),
        ),
        loadingWidget(
          message: "Aguarde...",
          isLoading: expeditionConferenceProvider.isLoading,
        )
      ],
    );
  }
}
