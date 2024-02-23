import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/customer_register/customer_register.dart';
import '../../providers/providers.dart';
import '../global_widgets/global_widgets.dart';

class CustomerRegisterAdressesInformeds extends StatefulWidget {
  const CustomerRegisterAdressesInformeds({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomerRegisterAdressesInformeds> createState() =>
      _CustomerRegisterAdressesInformedsState();
}

class _CustomerRegisterAdressesInformedsState
    extends State<CustomerRegisterAdressesInformeds> {
  String _getState({
    required CustomerRegisterProvider customerRegisterProvider,
    required CustomerRegisterCepModel customerRegisterCepModel,
  }) {
    int? index =
        customerRegisterProvider.adresses.indexOf(customerRegisterCepModel);

    return customerRegisterProvider.adresses[index].State!;
  }

  @override
  Widget build(BuildContext context) {
    CustomerRegisterProvider customerRegisterProvider = Provider.of(context);
    return Column(
      children: [
        const Divider(
          height: 20,
        ),
        const Text(
          "Endereços informados",
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
          itemCount: customerRegisterProvider.adressesCount,
          itemBuilder: ((context, index) {
            CustomerRegisterCepModel customerRegisterCepModel =
                customerRegisterProvider.adresses[index];

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "CEP",
                      value: customerRegisterCepModel.Zip,
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
                      value: _getState(
                        customerRegisterProvider: customerRegisterProvider,
                        customerRegisterCepModel: customerRegisterCepModel,
                      ),
                    ),
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "Número",
                      value: customerRegisterCepModel.Number.toString(),
                    ),
                    if (customerRegisterCepModel.Complement != "")
                      TitleAndSubtitle.titleAndSubtitle(
                        title: "Complemento",
                        value: customerRegisterCepModel.Complement,
                      ),
                    if (customerRegisterCepModel.Reference != "")
                      TitleAndSubtitle.titleAndSubtitle(
                        title: "Referência",
                        value: customerRegisterCepModel.Reference,
                      ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          customerRegisterProvider.isLoadingInsertCustomer
                              ? Colors.grey
                              : Colors.red,
                        ),
                        minimumSize:
                            const MaterialStatePropertyAll(Size(100, 30)),
                        maximumSize: const MaterialStatePropertyAll(
                            Size(double.infinity, 30)),
                      ),
                      onPressed: customerRegisterProvider
                              .isLoadingInsertCustomer
                          ? null
                          : () {
                              ShowAlertDialog.showAlertDialog(
                                context: context,
                                title: "Remover endereço",
                                subtitle:
                                    "Deseja realmente remover o endereço?",
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
