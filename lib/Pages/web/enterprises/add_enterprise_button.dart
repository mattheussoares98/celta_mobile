import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/web_provider.dart';
import 'components/components.dart';

class AddEnterpriseButton extends StatefulWidget {
  const AddEnterpriseButton({super.key});

  @override
  State<AddEnterpriseButton> createState() => _AddEnterpriseButtonState();
}

class _AddEnterpriseButtonState extends State<AddEnterpriseButton> {
  final _enterpriseController = TextEditingController();
  final _urlCcsController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _surnameController = TextEditingController();
  final _ccsFocusNode = FocusNode();
  final _enterpriseFocusNode = FocusNode();
  final _cnpjFocusNode = FocusNode();
  final _surnameFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _enterpriseController.dispose();
    _urlCcsController.dispose();
    _cnpjController.dispose();
    _surnameController.dispose();
    _ccsFocusNode.dispose();
    _enterpriseFocusNode.dispose();
    _cnpjFocusNode.dispose();
    _surnameFocusNode.dispose();
  }

  Future<void> addEnterprise(WebProvider webProvider) async {
    bool? isValid = _formKey.currentState?.validate();

    if (isValid != true) {
      return;
    }

    await webProvider.addNewEnterprise(
      context: context,
      enterpriseName: _enterpriseController.text,
      urlCcs: _urlCcsController.text,
      cnpjs: webProvider.cnpjsToAdd,
    );
  }

  @override
  Widget build(BuildContext context) {
    WebProvider webProvider = Provider.of(context);

    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              content: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            EnterpriseNameInput(
                              enterpriseController: _enterpriseController,
                              enterpriseFocusNode: _enterpriseFocusNode,
                              ccsFocusNode: _ccsFocusNode,
                            ),
                            CcsUrlInput(
                              urlCcsController: _urlCcsController,
                              ccsFocusNode: _ccsFocusNode,
                              cnpjFocusNode: _cnpjFocusNode,
                            ),
                            CnpjAndSurnameInput(
                              cnpjController: _cnpjController,
                              cnpjFocusNode: _cnpjFocusNode,
                              surnameController: _surnameController,
                              surnameFocusNode: _surnameFocusNode,
                            ),
                            TextButton(
                              onPressed: () async {
                                await addEnterprise(webProvider);
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
              ),
            );
          },
        );
        _enterpriseController.clear();
        _urlCcsController.clear();
        _cnpjController.clear();
        webProvider.clearCnpjs();
      },
    );
  }
}
