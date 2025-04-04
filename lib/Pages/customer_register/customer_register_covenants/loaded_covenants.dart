import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Models/models.dart';
import '../../../components/components.dart';
import '../../../providers/providers.dart';

class LoadedCovenants extends StatelessWidget {
  final List<CustomerRegisterCovenantModel> notInsertedCovenants;
  final FocusNode limitFocusNode;
  const LoadedCovenants({
    super.key,
    required this.notInsertedCovenants,
    required this.limitFocusNode,
  });

  void updateSelectedCovenant(
    CustomerRegisterProvider customerRegisterProvider,
    CustomerRegisterCovenantModel covenant,
  ) {
    customerRegisterProvider.updateSelectedCovenant(covenant);
    if (customerRegisterProvider.selectedCovenant != null) {
      Future.delayed(const Duration(milliseconds: 100), () {
        limitFocusNode.requestFocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CustomerRegisterProvider customerRegisterProvider = Provider.of(context);

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: notInsertedCovenants.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Text(
            "Convênios sem vínculo",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "BebasNeue",
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          );
        }

        final covenant = notInsertedCovenants[index - 1];
        //TODO test what happens if dont load covenants
        return Card(
          child: InkWell(
            onTap: () {
              updateSelectedCovenant(customerRegisterProvider, covenant);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TitleAndSubtitle.titleAndSubtitle(
                          title: "Nome",
                          subtitle: covenant.Nome_Convenio,
                        ),
                        TitleAndSubtitle.titleAndSubtitle(
                          title: "CNPJ",
                          subtitle: covenant.Cnpj_Convenio,
                        ),
                        TitleAndSubtitle.titleAndSubtitle(
                          title: "Endereço",
                          subtitle: (covenant.Logradouro_Convenio ?? "") +
                              " " +
                              (covenant.NumEndereco_Convenio ?? ""),
                        ),
                      ],
                    ),
                  ),
                  Checkbox(
                    value:
                        customerRegisterProvider.selectedCovenant == covenant,
                    onChanged: (_) {
                      updateSelectedCovenant(
                          customerRegisterProvider, covenant);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
