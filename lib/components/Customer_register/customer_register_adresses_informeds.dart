import 'package:celta_inventario/models/address/address.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    required AddressProvider addressProvider,
    required AddressModel addressModel,
  }) {
    int? index = addressProvider.adresses.indexOf(addressModel);

    return addressProvider.adresses[index].State!;
  }

  @override
  Widget build(BuildContext context) {
    AddressProvider addressProvider = Provider.of(context);
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
          itemCount: addressProvider.adressesCount,
          itemBuilder: ((context, index) {
            AddressModel addressModel = addressProvider.adresses[index];

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "CEP",
                      value: addressModel.Zip,
                    ),
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "Logradouro",
                      value: addressModel.Address,
                    ),
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "Bairro",
                      value: addressModel.District,
                    ),
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "Cidade",
                      value: addressModel.City,
                    ),
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "Estado",
                      value: _getState(
                        addressProvider: addressProvider,
                        addressModel: addressModel,
                      ),
                    ),
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "Número",
                      value: addressModel.Number.toString(),
                    ),
                    if (addressModel.Complement != "")
                      TitleAndSubtitle.titleAndSubtitle(
                        title: "Complemento",
                        value: addressModel.Complement,
                      ),
                    if (addressModel.Reference != "")
                      TitleAndSubtitle.titleAndSubtitle(
                        title: "Referência",
                        value: addressModel.Reference,
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
                      onPressed:
                          customerRegisterProvider.isLoadingInsertCustomer
                              ? null
                              : () {
                                  ShowAlertDialog.showAlertDialog(
                                    context: context,
                                    title: "Remover endereço",
                                    subtitle:
                                        "Deseja realmente remover o endereço?",
                                    function: () {
                                      addressProvider.removeAdress(index);
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
