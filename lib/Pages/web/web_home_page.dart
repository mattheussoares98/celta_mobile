import 'package:celta_inventario/models/firebase/firebase.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import 'package:celta_inventario/components/global_widgets/global_widgets.dart';
import 'package:celta_inventario/providers/providers.dart';
import 'package:celta_inventario/utils/utils.dart';

class WebHomePage extends StatefulWidget {
  const WebHomePage({super.key});

  @override
  State<WebHomePage> createState() => _WebHomePageState();
}

class _WebHomePageState extends State<WebHomePage> {
  @override
  Widget build(BuildContext context) {
    WebProvider webProvider = Provider.of(context);
    return Stack(
      children: [
        Scaffold(
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: webProvider.clients.length,
                  itemBuilder: (context, index) {
                    FirebaseClientModel client = webProvider.clients[index];
                    return ListTile(
                      title: Text(client.enterpriseName),
                      subtitle: Text(client.urlCCS),
                    );
                  },
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () async {
                    await webProvider.getAllClients();

                    if (webProvider.errorMessage != "") {
                      ShowSnackbarMessage.showMessage(
                        message: DefaultErrorMessageToFindServer.ERROR_MESSAGE,
                        context: context,
                      );
                    }
                  },
                  child: const Text(
                    "Consultar clientes",
                  ),
                ),
              ),
            ],
          ),
        ),
        loadingWidget(
          message: "Consultando clientes...",
          isLoading: webProvider.isLoading,
        ),
      ],
    );
  }
}
