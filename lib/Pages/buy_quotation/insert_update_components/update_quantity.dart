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

  @override
  Widget build(BuildContext context) {
    BuyQuotationProvider buyQuotationProvider = Provider.of(context);
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: buyQuotationProvider.selectedEnterprises.length,
          itemBuilder: (context, index) {
            final enterprise = buyQuotationProvider.selectedEnterprises[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextFormField(
                controller: controllers[index],
                style: const TextStyle(fontSize: 14),
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
    );
  }
}
