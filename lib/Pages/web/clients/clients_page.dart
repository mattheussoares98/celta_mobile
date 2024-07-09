import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../components/global_widgets/global_widgets.dart';
import '../../../models/firebase/firebase.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});

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

                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              APPROUTES.WEB_ENTERPRISE_DETAILS,
                              arguments: client,
                            );
                          },
                          trailing: Icon(
                            Icons.remove_red_eye_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          ),
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

                        if (webProvider.errorMessageClients != "") {
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
        loadingWidget(message: "Aguarde...", isLoading: webProvider.isLoading),
      ],
    );
  }
}
