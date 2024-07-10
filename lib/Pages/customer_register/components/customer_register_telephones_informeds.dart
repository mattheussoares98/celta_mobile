import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/providers.dart';
import '../../../components/components.dart';

class CustomerRegisterTelephonesInformeds extends StatefulWidget {
  const CustomerRegisterTelephonesInformeds({Key? key}) : super(key: key);

  @override
  State<CustomerRegisterTelephonesInformeds> createState() =>
      _CustomerRegisterTelephonesInformedsState();
}

class _CustomerRegisterTelephonesInformedsState
    extends State<CustomerRegisterTelephonesInformeds> {
  String formatPhoneNumber({
    required String AreaCode,
    required String PhoneNumber,
  }) {
    return "($AreaCode) $PhoneNumber";
  }

  @override
  Widget build(BuildContext context) {
    CustomerRegisterProvider customerRegisterProvider =
        Provider.of(context, listen: true);
    return Column(
      children: [
        const Divider(
          height: 20,
        ),
        const Text(
          "Telefones informados",
          style: TextStyle(
            fontFamily: "BebasNeue",
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: customerRegisterProvider.telephonesCount,
          itemBuilder: (context, index) {
            Map<String, String> telephone =
                customerRegisterProvider.telephones[index];
            return Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      formatPhoneNumber(
                          AreaCode: telephone["AreaCode"]!,
                          PhoneNumber: telephone["PhoneNumber"]!),
                    ),
                  ),
                  IconButton(
                    onPressed: customerRegisterProvider.isLoadingInsertCustomer
                        ? null
                        : () {
                            ShowAlertDialog.showAlertDialog(
                              context: context,
                              title: "Excluir telefone",
                              subtitle: "Deseja realmente excluir o telefone?",
                              function: () {
                                customerRegisterProvider.removeTelephone(index);
                              },
                            );
                          },
                    icon: Icon(
                      Icons.delete,
                      size: 30,
                      color: customerRegisterProvider.isLoadingInsertCustomer
                          ? Colors.grey
                          : Colors.red,
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
