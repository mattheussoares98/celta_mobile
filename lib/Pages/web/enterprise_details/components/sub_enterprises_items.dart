import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../providers/providers.dart';
import '../../components/components.dart';

class SubEnterprisesItems extends StatelessWidget {
  const SubEnterprisesItems({super.key});

  @override
  Widget build(BuildContext context) {
    WebProvider webProvider = Provider.of(context);

    return Column(
      children: [
        const Divider(),
        Row(
          children: [
            Expanded(
              child: const Text(
                "Sub empresas",
                style: const TextStyle(
                  fontFamily: "BebasNeue",
                  fontSize: 30,
                ),
              ),
            ),
            AddEnterpriseButton(isAddingNewCnpj: true),
          ],
        ),
        ListView.builder(
          itemCount: webProvider
                  .enterprises[webProvider.indexOfSelectedEnterprise]
                  .subEnterprises
                  ?.length ??
              0,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final item = webProvider
                .enterprises[webProvider.indexOfSelectedEnterprise]
                .subEnterprises?[index];

            return InkWell(
              onTap: () {},
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Apelido: ${item?.surname}"),
                            Text("Cnpj: ${item?.cnpj}"),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          ShowAlertDialog.show(
                              context: context,
                              title: "Remover sub empresa?",
                              function: () async {
                                await webProvider.removeSubEnterprise(index);
                              });
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.edit,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
