import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../providers/providers.dart';

class CustomerRegisterClearAllData extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController telephoneController;
  final TextEditingController dddController;
  final TextEditingController reducedNameController;
  final TextEditingController cpfCnpjController;
  final TextEditingController dateOfBirthController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmationController;
  const CustomerRegisterClearAllData({
    required this.nameController,
    required this.emailController,
    required this.telephoneController,
    required this.dddController,
    required this.reducedNameController,
    required this.cpfCnpjController,
    required this.dateOfBirthController,
    required this.passwordController,
    required this.passwordConfirmationController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CustomerRegisterProvider customerRegisterProvider = Provider.of(context);
    AddressProvider addressProvider = Provider.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: FloatingActionButton(
        tooltip: "Limpar todos os dados do pedido",
        onPressed:
            customerRegisterProvider.isLoading || nameController.text.isEmpty
                ? null
                : () {
                    ShowAlertDialog.show(
                      context: context,
                      title: "Apagar TODOS dados",
                      content: const SingleChildScrollView(
                        child: Text(
                          "Deseja realmente limpar todos os dados do pedido?",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      function: () {
                        customerRegisterProvider.clearAllDataInformed(
                          addressProvider: addressProvider,
                          emailController: emailController,
                          telephoneController: telephoneController,
                          dddController: dddController,
                          reducedNameController: reducedNameController,
                          cpfCnpjController: cpfCnpjController,
                          dateOfBirthController: dateOfBirthController,
                          nameController: nameController,
                          passwordController: passwordController,
                          passwordConfirmationController:
                              passwordConfirmationController,
                        );
                      },
                    );
                  },
        child: const Icon(Icons.delete, color: Colors.white),
        backgroundColor:
            customerRegisterProvider.isLoading || nameController.text.isEmpty
                ? Colors.grey.withAlpha(190)
                : Colors.red.withAlpha(190),
      ),
    );
  }
}
