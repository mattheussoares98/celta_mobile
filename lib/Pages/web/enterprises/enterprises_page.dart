import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../components/global_widgets/global_widgets.dart';
import '../../../models/firebase/firebase.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';

class EnterprisesPage extends StatelessWidget {
  const EnterprisesPage({super.key});
  @override
  Widget build(BuildContext context) {
    WebProvider webProvider = Provider.of(context);

    final _enterpriseController = TextEditingController();
    final _urlCcsController = TextEditingController();
    final _urlCcsFocusNode = FocusNode();
    final _enterpriseFocusNode = FocusNode();

    void addEnterprise() {
      ShowAlertDialog.showAlertDialog(
          context: context,
          title: "Adicionar cliente?",
          subtitle:
              "Empresa: ${_enterpriseController.text}\nUrl: ${_urlCcsController.text}",
          function: () async {
            if (!_urlCcsController.text.toLowerCase().contains("http") ||
                !_urlCcsController.text.contains(":") ||
                !_urlCcsController.text.contains("//") ||
                !_urlCcsController.text.contains("\.") ||
                !_urlCcsController.text.toLowerCase().contains("ccs")) {
              ShowSnackbarMessage.showMessage(
                message: "Pelo jeito essa URL tá errada. Confirma aeeew",
                context: context,
              );
            } else {
              await webProvider.addNewEnterprise(
                context: context,
                enterpriseName: _enterpriseController.text,
                urlCcs: _urlCcsController.text,
              );
            }
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: webProvider.clients.isEmpty
            ? null
            : Text(
                "${webProvider.clients.length} empresas",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      content: Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 30, 8, 8),
                                    child: TextFormField(
                                      autofocus: true,
                                      controller: _enterpriseController,
                                      focusNode: _enterpriseFocusNode,
                                      onFieldSubmitted: (value) {
                                        if (value.isEmpty == true) {
                                          FocusScope.of(context).requestFocus(
                                              _enterpriseFocusNode);
                                        } else {
                                          FocusScope.of(context)
                                              .requestFocus(_urlCcsFocusNode);
                                        }
                                      },
                                      decoration: FormFieldHelper.decoration(
                                        isLoading: webProvider.isLoading,
                                        context: context,
                                        hintText: "Nome da empresa",
                                        labelText: "Nome da empresa",
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: _urlCcsController,
                                      focusNode: _urlCcsFocusNode,
                                      onFieldSubmitted: (_) {
                                        if (_enterpriseController
                                                .text.isEmpty ==
                                            true) {
                                          FocusScope.of(context).requestFocus(
                                              _enterpriseFocusNode);
                                        } else {
                                          addEnterprise();
                                        }
                                      },
                                      decoration: FormFieldHelper.decoration(
                                        isLoading: webProvider.isLoading,
                                        context: context,
                                        hintText: "http://127.0.0.1:9092/ccs",
                                        labelText: "Url do CCS",
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      addEnterprise();
                                    },
                                    child: const Text("Adicionar"),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancelar"),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
            icon: const Icon(Icons.add),
          ),
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
                        message: DefaultErrorMessageToFindServer.ERROR_MESSAGE,
                        context: context,
                      );
                    }
                  },
                  child: const Text(
                    "Consultar empresas",
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
