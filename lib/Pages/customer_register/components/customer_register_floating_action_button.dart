import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/providers.dart';
import '../../../components/components.dart';

class CustomerRegisterFloatingActionButton extends StatefulWidget {
  final void Function() changeSelectedIndexToAddAddres; //TODO test if need this
  final void Function() changeFormKeysToInvalid; //TODO test if need this
  final TextEditingController passwordController;

  const CustomerRegisterFloatingActionButton({
    required this.changeSelectedIndexToAddAddres,
    required this.changeFormKeysToInvalid,
    required this.passwordController,
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
    AddressProvider addressProvider = Provider.of(context);

    return GestureDetector(
      onTap: customerRegisterProvider.isLoading
          ? null
          : () async {
              if (addressProvider.addressesCount == 0) {
                setState(() {
                  widget.changeSelectedIndexToAddAddres();
                });
              } else {
                ShowAlertDialog.show(
                  context: context,
                  title: "Cadastrar cliente",
                  content: const SingleChildScrollView(
                    child: Text(
                      "Deseja confirmar o cadastro do cliente?",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  function: () async {
                    await customerRegisterProvider.insertCustomer(
                      addressProvider: addressProvider,
                      password: widget.passwordController.text,
                    );

                    if (customerRegisterProvider.errorMessage == "") {
                      setState(() {
                        widget.changeFormKeysToInvalid();
                      });

                      ShowSnackbarMessage.show(
                        message: "Cliente inserido/atualizado com sucesso",
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        context: context,
                      );
                    } else {
                      ShowSnackbarMessage.show(
                        message: customerRegisterProvider.errorMessage,
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
        backgroundColor: customerRegisterProvider.isLoading
            ? Colors.grey[300]
            : Theme.of(context).colorScheme.primary,
        child: customerRegisterProvider.isLoading
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
                        addressProvider.addressesCount > 0
                            ? "SALVAR"
                            : "Adicione\num\nendereço",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (addressProvider.addressesCount > 0)
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
