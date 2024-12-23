import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../providers/providers.dart';

class UpdateQuantity extends StatelessWidget {
  final List<TextEditingController> controllers;
  final void Function() updateSelectedIndex;
  final int productIndex;

  const UpdateQuantity({
    required this.controllers,
    required this.updateSelectedIndex,
    required this.productIndex,
    super.key,
  });

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    BuyQuotationProvider buyQuotationProvider = Provider.of(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: buyQuotationProvider.selectedEnterprises.length,
            itemBuilder: (context, index) {
              final enterprise =
                  buyQuotationProvider.selectedEnterprises[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextFormField(
                  controller: controllers[index],
                  style: const TextStyle(fontSize: 14),
                  validator: (value) {
                    if (value == null || value.isEmpty == true) {
                      return null;
                    } else if (value.toDouble() == -1) {
                      return "Número inválido";
                    } else {
                      return null;
                    }
                  },
                  decoration: FormFieldDecoration.decoration(
                    context: context,
                    labelText: "Qtd ${enterprise.Name}",
                  ),
                ),
              );
            },
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: updateSelectedIndex,
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    bool? isValid = _formKey.currentState?.validate();

                    if (isValid != true) {
                      return;
                    }

                    buyQuotationProvider.updateProductQuantity(
                      quantitys:
                          controllers.map((e) => e.text.toDouble()).toList(),
                      productIndex: productIndex,
                    );
                    updateSelectedIndex();
                  },
                  child: Text(
                    "Alterar",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
