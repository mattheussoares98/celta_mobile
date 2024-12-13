import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../providers/web_provider.dart';

class AddEnterpriseButton extends StatefulWidget {
  const AddEnterpriseButton({super.key});

  @override
  State<AddEnterpriseButton> createState() => _AddEnterpriseButtonState();
}

class _AddEnterpriseButtonState extends State<AddEnterpriseButton> {
  final _enterpriseController = TextEditingController();
  final _urlCcsController = TextEditingController();
  final _urlCcsFocusNode = FocusNode();
  final _enterpriseFocusNode = FocusNode();

  void addEnterprise(WebProvider webProvider) {
    ShowAlertDialog.show(
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
            ShowSnackbarMessage.show(
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

  @override
  void dispose() {
    super.dispose();
    _enterpriseController.dispose();
    _urlCcsController.dispose();
    _urlCcsFocusNode.dispose();
    _enterpriseFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WebProvider webProvider = Provider.of(context);

    return IconButton(
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
                              padding: const EdgeInsets.fromLTRB(8, 30, 8, 8),
                              child: TextFormField(
                                autofocus: true,
                                controller: _enterpriseController,
                                focusNode: _enterpriseFocusNode,
                                onFieldSubmitted: (value) {
                                  if (value.isEmpty == true) {
                                    FocusScope.of(context)
                                        .requestFocus(_enterpriseFocusNode);
                                  } else {
                                    FocusScope.of(context)
                                        .requestFocus(_urlCcsFocusNode);
                                  }
                                },
                                decoration: FormFieldDecoration.decoration(
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
                                  if (_enterpriseController.text.isEmpty ==
                                      true) {
                                    FocusScope.of(context)
                                        .requestFocus(_enterpriseFocusNode);
                                  } else {
                                    addEnterprise(webProvider);
                                  }
                                },
                                decoration: FormFieldDecoration.decoration(
                                  context: context,
                                  hintText: "http://127.0.0.1:9092/ccs",
                                  labelText: "Url do CCS",
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                addEnterprise(webProvider);
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
    );
  }
}
