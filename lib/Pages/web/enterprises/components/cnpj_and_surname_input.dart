import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../models/models.dart';
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

  void addCnpj(WebProvider webProvider) {
    bool? isValid = cnpjFormKey.currentState?.validate();

    if (isValid != true) {
      return;
    }

    webProvider.addNewCnpj(
      CnpjModel(
        surname: surnameController.text,
        cnpj: cnpjController.text.toInt(),
      ),
    );
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
                    validator: FormFieldValidations.cpfOrCnpj,
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
                      addCnpj(webProvider);
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
                    addCnpj(webProvider);
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
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              webProvider.cnpjsToAdd.isEmpty
                  ? "Adicione pelo menos um CNPJ"
                  : "CNPJs adicionados",
            ),
          ),
          Card(
            child: ListView.builder(
              itemCount: webProvider.cnpjsToAdd.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color:
                        index % 2 == 0 ? Colors.grey[200] : Colors.transparent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Text(
                                  webProvider.cnpjsToAdd[index].surname + " -"),
                              const SizedBox(width: 8),
                              Text(webProvider.cnpjsToAdd[index].cnpj
                                  .toString()),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          webProvider.removeCnpj(index);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
