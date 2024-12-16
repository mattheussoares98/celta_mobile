import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../providers/providers.dart';

class ClearData extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController reducedNameController;
  final TextEditingController cpfCnpjController;
  final TextEditingController dateOfBirthController;
  const ClearData({
    required this.nameController,
    required this.reducedNameController,
    required this.cpfCnpjController,
    required this.dateOfBirthController,
    super.key,
  });

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
            content: const SingleChildScrollView(
              child: Text(
                "Deseja realmente limpar todos dados pessoais digitados?",
                textAlign: TextAlign.center,
              ),
            ),
            function: () {
              customerRegisterProvider.clearPersonalDataControllers(
                nameController: nameController,
                reducedNameController: reducedNameController,
                cpfCnpjController: cpfCnpjController,
                dateOfBirthController: dateOfBirthController,
              );
            },
          );
        },
        child: const Text("Limpar dados"),
      ),
    );
  }
}
