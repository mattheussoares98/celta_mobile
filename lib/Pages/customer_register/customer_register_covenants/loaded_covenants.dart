import 'package:flutter/material.dart';

import '../../../Models/models.dart';
import '../../../components/components.dart';
import '../customer_register.dart';

class LoadedCovenants extends StatelessWidget {
  final List<CustomerRegisterCovenantModel> notInsertedCovenants;
  const LoadedCovenants({super.key, required this.notInsertedCovenants});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Convênios sem vínculo",
          style: TextStyle(
            fontFamily: "BebasNeue",
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: notInsertedCovenants.length,
          itemBuilder: (context, index) {
            final covenant = notInsertedCovenants[index];

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
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
                    LimitAndBindCovenantButton(
                      covenant: covenant,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
