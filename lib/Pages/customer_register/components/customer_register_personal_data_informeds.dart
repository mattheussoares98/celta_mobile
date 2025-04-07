import 'package:flutter/material.dart';

import '../../../providers/providers.dart';
import '../../../components/components.dart';

class CustomerRegisterPersonalDataInformeds extends StatelessWidget {
  final CustomerRegisterProvider customerRegisterProvider;
  final TextEditingController nameController;
  final TextEditingController cpfCnpjController;
  final TextEditingController reducedNameController;
  final TextEditingController dateOfBirthController;
  final String? selectedSex;
  const CustomerRegisterPersonalDataInformeds({
    required this.customerRegisterProvider,
    required this.nameController,
    required this.cpfCnpjController,
    required this.reducedNameController,
    required this.dateOfBirthController,
    required this.selectedSex,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Dados pessoais informados",
          style: TextStyle(
            fontFamily: "BebasNeue",
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Nome",
                  subtitle: nameController.text,
                ),
                if (cpfCnpjController.text != "")
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "CPF/CNPJ",
                    subtitle: cpfCnpjController.text,
                  ),
                if (reducedNameController.text != "")
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Nome reduzido",
                    subtitle: reducedNameController.text,
                  ),
                if (dateOfBirthController.text != "")
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Data de nascimento",
                    subtitle: dateOfBirthController.text,
                  ),
                if (selectedSex != null)
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Sexo",
                    subtitle: selectedSex,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
