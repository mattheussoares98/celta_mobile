import 'package:celta_inventario/components/Global_widgets/personalized_card.dart';
import 'package:celta_inventario/components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/providers/customer_register_provider.dart';
import 'package:flutter/material.dart';

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
        const Divider(
          height: 20,
        ),
        const Text(
          "Dados pessoais informados",
          style: TextStyle(
            fontFamily: "BebasNeue",
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        PersonalizedCard.personalizedCard(
          context: context,
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
