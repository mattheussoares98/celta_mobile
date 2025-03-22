import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../models/models.dart';
import './components/components.dart';
import '../../providers/providers.dart';

class ExpeditionConferenceControlsToConferencePage extends StatefulWidget {
  const ExpeditionConferenceControlsToConferencePage({super.key});

  @override
  State<ExpeditionConferenceControlsToConferencePage> createState() =>
      _ExpeditionConferenceControlsToConferencePageState();
}

class _ExpeditionConferenceControlsToConferencePageState
    extends State<ExpeditionConferenceControlsToConferencePage> {
  Future<void> _getExpeditionControlsToConference() async {
    await Future.delayed(Duration.zero);

    ExpeditionConferenceProvider expeditionConferenceProvider =
        Provider.of(context, listen: false);

    EnterpriseModel enterprise =
        ModalRoute.of(context)!.settings.arguments as EnterpriseModel;

    await expeditionConferenceProvider.getExpeditionControlsToConference(
      enterprise: enterprise,
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
            title: const FittedBox(
                child: Text("Controles na etapa de conferência")),
            actions: [
              IconButton(
                onPressed: () async {
                  await expeditionConferenceProvider
                      .getExpeditionControlsToConference(
                    enterprise: enterprise,
                  );
                },
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (expeditionConferenceProvider.errorMessage != "" &&
                  expeditionConferenceProvider
                      .expeditionControlsToConference.isEmpty)
                searchAgain(
                    errorMessage: expeditionConferenceProvider.errorMessage,
                    request: () async {
                      await expeditionConferenceProvider
                          .getExpeditionControlsToConference(
                        enterprise: enterprise,
                      );
                    }),
              const Expanded(child: ExpeditionControlsToConferenceItems()),
            ],
          ),
        ),
        loadingWidget(expeditionConferenceProvider.isLoading)
      ],
    );
  }
}
