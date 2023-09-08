import 'package:celta_inventario/Models/customer_register_models/customer_register_cep.dart';
import 'package:celta_inventario/components/Global_widgets/personalized_card.dart';
import 'package:celta_inventario/components/Global_widgets/show_alert_dialog.dart';
import 'package:celta_inventario/components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/providers/customer_register_provider.dart';
import 'package:flutter/material.dart';

class CustomerRegisterAdressesInserteds extends StatelessWidget {
  final CustomerRegisterProvider customerRegisterProvider;
  const CustomerRegisterAdressesInserteds({
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
          "Endereços inseridos",
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
          itemCount: customerRegisterProvider.adressessCount,
          itemBuilder: ((context, index) {
            CustomerRegisterCepModel customerRegisterCepModel =
                customerRegisterProvider.adressess[index];

            return PersonalizedCard.personalizedCard(
              context: context,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "CEP",
                      value: customerRegisterCepModel.zip,
                    ),
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "Logradouro",
                      value: customerRegisterCepModel.Address,
                    ),
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "Bairro",
                      value: customerRegisterCepModel.District,
                    ),
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "Cidade",
                      value: customerRegisterCepModel.City,
                    ),
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "Estado",
                      value: customerRegisterCepModel.State,
                    ),
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "Número",
                      value: customerRegisterCepModel.number.toString(),
                    ),
                    if (customerRegisterCepModel.Complement != "")
                      TitleAndSubtitle.titleAndSubtitle(
                        title: "Complemento",
                        value: customerRegisterCepModel.Complement,
                      ),
                    if (customerRegisterCepModel.reference != "")
                      TitleAndSubtitle.titleAndSubtitle(
                        title: "Referência",
                        value: customerRegisterCepModel.reference,
                      ),
                    ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.red),
                        minimumSize: MaterialStatePropertyAll(Size(100, 30)),
                        maximumSize:
                            MaterialStatePropertyAll(Size(double.infinity, 30)),
                      ),
                      onPressed: () {
                        ShowAlertDialog().showAlertDialog(
                          context: context,
                          title: "Remover endereço",
                          subtitle: "Deseja realmente remover o endereço?",
                          function: () {
                            customerRegisterProvider.removeAdress(index);
                          },
                        );
                      },
                      child: const Text("Remover endereço"),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
