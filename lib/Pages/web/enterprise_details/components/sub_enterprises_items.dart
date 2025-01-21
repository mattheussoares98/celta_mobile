import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../models/models.dart';
import '../../../../providers/providers.dart';
import '../../../../utils/utils.dart';
import '../../components/components.dart';

class SubEnterprisesItems extends StatelessWidget {
  const SubEnterprisesItems({super.key});

  void goToAddOrEditSubEnterprisePage({
    required SubEnterpriseModel? selectedSubEnterprise,
    required BuildContext context,
    required bool updatingAllSubenterprises,
  }) {
    Navigator.of(context).pushNamed(
      APPROUTES.ADD_UPDATE_SUB_ENTERPRISE,
      arguments: {
        "selectedSubEnterprise": selectedSubEnterprise,
        "updatingAllSubenterprises": updatingAllSubenterprises,
      },
    );
  }

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
        if (webProvider.indexOfSelectedEnterprise != -1)
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
                onTap: () {
                  goToAddOrEditSubEnterprisePage(
                    selectedSubEnterprise: item,
                    context: context,
                    updatingAllSubenterprises: false,
                  );
                },
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
                              if (item?.modules != null)
                                Builder(builder: (context) {
                                  final disabledModules = item?.modules!
                                      .where((e) => !e.enabled)
                                      .toList();
                                  if (disabledModules?.isEmpty == true) {
                                    return Text(
                                      "Todos módulos estão habilitados",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    );
                                  }
                                  return Wrap(
                                    children: item!.modules!
                                        .map(
                                          (e) => Text(
                                            e.name + "; ",
                                            style: TextStyle(
                                              color: e.enabled
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                  : Colors.red,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  );
                                }),
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
                          onPressed: () {
                            goToAddOrEditSubEnterprisePage(
                              selectedSubEnterprise: item,
                              context: context,
                              updatingAllSubenterprises: false,
                            );
                          },
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
        if (webProvider.enterprises.isNotEmpty &&
            webProvider.indexOfSelectedEnterprise != -1 &&
            webProvider.enterprises[webProvider.indexOfSelectedEnterprise]
                    .subEnterprises?.length !=
                null &&
            webProvider.enterprises[webProvider.indexOfSelectedEnterprise]
                    .subEnterprises!.length >
                1)
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: TextButton(
              onPressed: () {
                goToAddOrEditSubEnterprisePage(
                  selectedSubEnterprise: null,
                  context: context,
                  updatingAllSubenterprises: true,
                );
              },
              child: Text("Deixar módulos iguais em todas sub empresas"),
            ),
          ),
      ],
    );
  }
}
