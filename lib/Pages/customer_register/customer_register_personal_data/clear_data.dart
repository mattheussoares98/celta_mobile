import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../providers/providers.dart';

class ClearData extends StatelessWidget {
  const ClearData({super.key});

  @override
  Widget build(BuildContext context) {
    CustomerRegisterProvider customerRegisterProvider = Provider.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        onPressed: () {
          ShowAlertDialog.show(
            context: context,
            title: "Limpar dados",
            subtitle: "Deseja realmente limpar todos dados pessoais digitados?",
            function: () {
              customerRegisterProvider.clearPersonalDataControllers();
            },
          );
        },
        child: const Text("Limpar dados"),
      ),
    );
  }
}
