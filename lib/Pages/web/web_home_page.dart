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
          appBar: AppBar(
            title: webProvider.clients.isEmpty
                ? null
                : Text(
                    "${webProvider.clients.length} clientes",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
            actions: [
              IconButton(
                  onPressed: () async {
                    await webProvider.getAllClients();
                  },
                  icon: const Icon(
                    Icons.refresh,
                  )),
            ],
          ),
          body: Column(
            children: [
              if (webProvider.clients.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: webProvider.clients.length,
                    itemBuilder: (context, index) {
                      FirebaseClientModel client = webProvider.clients[index];
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            APPROUTES.WEB_ENTERPRISE_DETAILS,
                            arguments: client,
                          );
                        },
                        trailing: IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                APPROUTES.WEB_ENTERPRISE_DETAILS,
                                arguments: client,
                              );
                            },
                            icon: Icon(
                              Icons.remove_red_eye_rounded,
                              color: Theme.of(context).colorScheme.primary,
                            )),
                        title: Text(client.enterpriseName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(client.urlCCS),
                            if (client.usersInformations != null)
                              Text(
                                  "Quantidade de usuários: ${client.usersInformations!.length}"),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              if (webProvider.clients.isEmpty)
                Expanded(
                  child: Center(
                    child: TextButton(
                      onPressed: () async {
                        await webProvider.getAllClients();

                        if (webProvider.errorMessage != "") {
                          ShowSnackbarMessage.showMessage(
                            message:
                                DefaultErrorMessageToFindServer.ERROR_MESSAGE,
                            context: context,
                          );
                        }
                      },
                      child: const Text(
                        "Consultar clientes",
                      ),
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
