import 'package:flutter/material.dart';

import '../../providers/providers.dart';
import '../global_widgets/global_widgets.dart';

class CustomerRegisterPersonalDataInformeds extends StatelessWidget {
  final CustomerRegisterProvider customerRegisterProvider;
  const CustomerRegisterPersonalDataInformeds({
    required this.customerRegisterProvider,
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
                  value: customerRegisterProvider.nameController.text,
                ),
                if (customerRegisterProvider.cpfCnpjController.text != "")
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "CPF/CNPJ",
                    value: customerRegisterProvider.cpfCnpjController.text,
                  ),
                if (customerRegisterProvider.reducedNameController.text != "")
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Nome reduzido",
                    value: customerRegisterProvider.reducedNameController.text,
                  ),
                if (customerRegisterProvider.dateOfBirthController.text != "")
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Data de nascimento",
                    value: customerRegisterProvider.dateOfBirthController.text,
                  ),
                if (customerRegisterProvider.selectedSexDropDown.value != null)
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Sexo",
                    value: customerRegisterProvider.selectedSexDropDown.value,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
