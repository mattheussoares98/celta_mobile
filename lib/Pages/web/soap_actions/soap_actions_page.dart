import 'package:celta_inventario/pages/web/soap_actions/soap_actions.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../components/mixins/mixins.dart';
import '../../../providers/providers.dart';

class SoapActionsPage extends StatefulWidget {
  const SoapActionsPage({super.key});

  @override
  State<SoapActionsPage> createState() => _SoapActionsPageState();
}

class _SoapActionsPageState extends State<SoapActionsPage> with LoadingManager {
  @override
  Widget build(BuildContext context) {
    WebProvider webProvider = Provider.of(context);
    Future.delayed(Duration.zero, () {
      handleLoading(context, webProvider.isLoadingSoapActions);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("TOTAL DE REQUISIÇÕES"),
      ),
      body: webProvider.clientsNames.isEmpty
          ? Center(
              child: TextButton(
                onPressed: () async {
                  await webProvider.getLastThreeMonthsSoapActions();
                },
                child: const Text("Carregar requisições"),
              ),
            )
          : const SoapActionsItems(),
    );
  }
}
