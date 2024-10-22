import 'package:celta_inventario/pages/customer_register/customer_register.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../components/components.dart';
import '../../../providers/providers.dart';

class LoadedCovenants extends StatelessWidget {
  const LoadedCovenants({super.key});

  @override
  Widget build(BuildContext context) {
    CustomerRegisterProvider customerRegisterProvider = Provider.of(context);

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
          shrinkWrap: true,
          itemCount: customerRegisterProvider.covenants.length,
          itemBuilder: (context, index) {
            final covenant = customerRegisterProvider.covenants[index];

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
                    LimitAndBindCovenantButton(index: index),
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
