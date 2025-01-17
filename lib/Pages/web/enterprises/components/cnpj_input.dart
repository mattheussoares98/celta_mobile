import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../providers/providers.dart';

class CnpjInput extends StatelessWidget {
  final TextEditingController cnpjController;
  final FocusNode cnpjFocusNode;
  const CnpjInput({
    required this.cnpjController,
    required this.cnpjFocusNode,
    super.key,
  });

  static final cnpjFormKey = GlobalKey<FormState>();

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
            child: TextFormField(
              controller: cnpjController,
              focusNode: cnpjFocusNode,
              validator: FormFieldValidations.cpfOrCnpj,
              onFieldSubmitted: (value) async {
                if (value.isEmpty) {
                  cnpjFocusNode.requestFocus();
                } else {
                  bool? isValid = cnpjFormKey.currentState?.validate();
                  if (isValid != true) {
                    Future.delayed(Duration.zero, () {
                      cnpjFocusNode.requestFocus();
                    });
                    return;
                  }
                  webProvider.addNewCnpj(value);
                  cnpjController.clear();
                }
              },
              decoration: FormFieldDecoration.decoration(
                context: context,
                hintText: "Somente números",
                labelText: "CNPJ",
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(webProvider.cnpjsToAdd.isEmpty
                ? "Adicione pelo menos um CNPJ"
                : "CNPJs adicionados"),
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
                        child: Text(webProvider.cnpjsToAdd[index]),
                      )),
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
