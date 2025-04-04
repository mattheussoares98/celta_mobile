import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/providers.dart';
import '../../../components/components.dart';

class CustomerRegisterEmailsInformeds extends StatefulWidget {
  const CustomerRegisterEmailsInformeds({Key? key}) : super(key: key);

  @override
  State<CustomerRegisterEmailsInformeds> createState() =>
      _CustomerRegisterEmailsInformedsState();
}

class _CustomerRegisterEmailsInformedsState
    extends State<CustomerRegisterEmailsInformeds> {
  @override
  Widget build(BuildContext context) {
    CustomerRegisterProvider customerRegisterProvider =
        Provider.of(context, listen: true);
    ;
    return Column(
      children: [
        const Divider(
          height: 20,
        ),
        const Text(
          "E-mails informados",
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
          itemCount: customerRegisterProvider.customer?.Emails?.length ?? 0,
          itemBuilder: (context, index) {
            final email = customerRegisterProvider.customer!.Emails![index];
            return Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(email),
                  ),
                  IconButton(
                    onPressed: customerRegisterProvider.isLoading
                        ? null
                        : () {
                            ShowAlertDialog.show(
                              context: context,
                              title: "Excluir e-mail",
                              content: const SingleChildScrollView(
                                child: Text(
                                  "Deseja realmente excluir o e-mail?",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              function: () {
                                customerRegisterProvider.removeEmail(index);
                              },
                            );
                          },
                    icon: Icon(
                      Icons.delete,
                      size: 30,
                      color: customerRegisterProvider.isLoading
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
