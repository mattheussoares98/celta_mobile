import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../global_widgets/global_widgets.dart';

class CustomerRegisterFloatingActionButton extends StatefulWidget {
  final Function changeSelectedIndexToAddAddres;
  final Function changeFormKeysToInvalid;
  const CustomerRegisterFloatingActionButton({
    required this.changeSelectedIndexToAddAddres,
    required this.changeFormKeysToInvalid,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomerRegisterFloatingActionButton> createState() =>
      _CustomerRegisterFloatingActionButtonState();
}

class _CustomerRegisterFloatingActionButtonState
    extends State<CustomerRegisterFloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    CustomerRegisterProvider customerRegisterProvider = Provider.of(context);

    return InkWell(
      onTap: customerRegisterProvider.isLoadingInsertCustomer
          ? null
          : () async {
              if (customerRegisterProvider.adressesCount == 0) {
                setState(() {
                  widget.changeSelectedIndexToAddAddres();
                });
              } else {
                ShowAlertDialog.showAlertDialog(
                  context: context,
                  title: "Cadastrar cliente",
                  subtitle: "Deseja confirmar o cadastro do cliente?",
                  function: () async {
                    await customerRegisterProvider.insertCustomer();

                    if (customerRegisterProvider.errorMessageInsertCustomer ==
                        "") {
                      setState(() {
                        widget.changeFormKeysToInvalid();
                      });

                      ShowSnackbarMessage.showMessage(
                        message: "Cliente inserido/atualizado com sucesso",
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        context: context,
                      );
                    } else {
                      ShowSnackbarMessage.showMessage(
                        message:
                            customerRegisterProvider.errorMessageInsertCustomer,
                        context: context,
                      );
                    }
                  },
                );
              }
            },
      child: CircleAvatar(
        minRadius: 35,
        maxRadius: 35,
        backgroundColor: customerRegisterProvider.isLoadingInsertCustomer
            ? Colors.grey[300]
            : Theme.of(context).colorScheme.primary,
        child: customerRegisterProvider.isLoadingInsertCustomer
            ? FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    children: [
                      Text(
                        "SALVANDO",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          height: 8,
                          width: 100,
                          child: LinearProgressIndicator(
                            minHeight: 2,
                            backgroundColor: Colors.grey[300],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        customerRegisterProvider.adressesCount > 0
                            ? "SALVAR"
                            : "Adicione\num\nendereço",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (customerRegisterProvider.adressesCount > 0)
                        const Icon(
                          Icons.person_add,
                          color: Colors.white,
                          size: 50,
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
