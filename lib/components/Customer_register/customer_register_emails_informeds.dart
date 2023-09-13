import 'package:celta_inventario/components/Global_widgets/personalized_card.dart';
import 'package:celta_inventario/components/Global_widgets/show_alert_dialog.dart';
import 'package:celta_inventario/providers/customer_register_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          itemCount: customerRegisterProvider.emailsCount,
          itemBuilder: (context, index) {
            String email = customerRegisterProvider.emails[index];
            return PersonalizedCard.personalizedCard(
              context: context,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      email,
                    ),
                  ),
                  IconButton(
                    onPressed: customerRegisterProvider.isLoadingInsertCustomer
                        ? null
                        : () {
                            ShowAlertDialog().showAlertDialog(
                              context: context,
                              title: "Excluir e-mail",
                              subtitle: "Deseja realmente excluir o e-mail?",
                              function: () {
                                customerRegisterProvider.removeEmail(index);
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
