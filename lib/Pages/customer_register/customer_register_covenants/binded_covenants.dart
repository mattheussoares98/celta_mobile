import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';

class BindedCovenants extends StatelessWidget {
  const BindedCovenants({super.key});

  @override
  Widget build(BuildContext context) {
    CustomerRegisterProvider customerRegisterProvider = Provider.of(context);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: customerRegisterProvider.bindedCovenants.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Column(
            children: [
              Divider(height: 20),
              Text(
                "Convênios vinculados",
                style: TextStyle(
                  fontFamily: "BebasNeue",
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          );
        }
        final binded = customerRegisterProvider.bindedCovenants[index - 1];

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Nome",
                  subtitle: binded.customerRegisterCovenantModel.Nome_Convenio,
                ),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "CNPJ",
                  subtitle: binded.customerRegisterCovenantModel.Cnpj_Convenio,
                ),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Limite",
                  subtitle: binded.limit
                      .toString()
                      .toBrazilianNumber()
                      .addBrazilianCoin(),
                ),
                TextButton(
                  onPressed: () {
                    customerRegisterProvider.unbindCovenant(index - 1);
                  },
                  child: const Text("Desvincular convênio"),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
