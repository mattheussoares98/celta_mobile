import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/global_widgets/global_widgets.dart';
import '../../../models/address/address.dart';
import '../../../providers/providers.dart';

class CustomerRegisterAddressesInformeds extends StatefulWidget {
  final bool isLoading;
  const CustomerRegisterAddressesInformeds({
    required this.isLoading,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomerRegisterAddressesInformeds> createState() =>
      _CustomerRegisterAddressesInformedsState();
}

class _CustomerRegisterAddressesInformedsState
    extends State<CustomerRegisterAddressesInformeds> {
  String _getState({
    required AddressProvider addressProvider,
    required AddressModel addressModel,
  }) {
    int? index = addressProvider.addresses.indexOf(addressModel);

    return addressProvider.addresses[index].State!;
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
          itemCount: addressProvider.addressesCount,
          itemBuilder: ((context, index) {
            AddressModel addressModel = addressProvider.addresses[index];

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
                        backgroundColor: WidgetStatePropertyAll(
                          customerRegisterProvider.isLoadingInsertCustomer
                              ? Colors.grey
                              : Colors.red,
                        ),
                        minimumSize:
                            const WidgetStatePropertyAll(Size(100, 30)),
                        maximumSize: const WidgetStatePropertyAll(
                            Size(double.infinity, 30)),
                      ),
                      onPressed:
                          customerRegisterProvider.isLoadingInsertCustomer ||
                                  widget.isLoading
                              ? null
                              : () {
                                  ShowAlertDialog.showAlertDialog(
                                    context: context,
                                    title: "Remover endereço",
                                    subtitle:
                                        "Deseja realmente remover o endereço?",
                                    function: () {
                                      addressProvider.removeAddress(index);
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
