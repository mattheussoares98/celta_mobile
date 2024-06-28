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
    // handleLoading(context, webProvider.isLoadingSoapActions);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Requisições",
        ),
      ),
      body: Center(
        child: TextButton(
          onPressed: () async {
            await webProvider.getAllSoapActions();
          },
          child: const Text("Carregar dados"),
        ),
      ),
    );
  }
}
