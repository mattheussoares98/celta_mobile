import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../providers/providers.dart';
import '../../../../utils/utils.dart';

class CnpjAndSurnameInput extends StatelessWidget {
  final TextEditingController cnpjController;
  final FocusNode cnpjFocusNode;
  final TextEditingController surnameController;
  final FocusNode surnameFocusNode;

  const CnpjAndSurnameInput({
    required this.cnpjController,
    required this.cnpjFocusNode,
    required this.surnameController,
    required this.surnameFocusNode,
    super.key,
  });

  static final cnpjFormKey = GlobalKey<FormState>();

  void addSubEnterprise(WebProvider webProvider) {
    bool? isValid = cnpjFormKey.currentState?.validate();

    if (isValid != true) {
      return;
    }

    surnameController.clear();
    cnpjController.clear();
    Future.delayed(Duration.zero, () {
      cnpjFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    WebProvider webProvider = Provider.of(context);

    return Form(
      key: cnpjFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: cnpjController,
                    focusNode: cnpjFocusNode,
                    validator: (value) {
                      if (value != null &&
                          webProvider
                                  .enterprises[
                                      webProvider.indexOfSelectedEnterprise]
                                  .subEnterprises!
                                  .indexWhere((e) => e.cnpj == value.toInt()) !=
                              -1) {
                        return "CNPJ já adicionado";
                      }
                      return FormFieldValidations.cpfOrCnpj(value);
                    },
                    onFieldSubmitted: (value) async {
                      if (value.isEmpty) {
                        Future.delayed(Duration.zero, () {
                          cnpjFocusNode.requestFocus();
                        });
                      } else {
                        surnameFocusNode.requestFocus();
                      }
                    },
                    decoration: FormFieldDecoration.decoration(
                      context: context,
                      hintText: "Somente números",
                      labelText: "CNPJ",
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: surnameController,
                    focusNode: surnameFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório";
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      addSubEnterprise(webProvider);
                    },
                    decoration: FormFieldDecoration.decoration(
                      context: context,
                      hintText: "Apelido",
                      labelText: "Apelido",
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    addSubEnterprise(webProvider);
                  },
                  label: Text("Adicionar"),
                  icon: Icon(
                    Icons.verified_sharp,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
