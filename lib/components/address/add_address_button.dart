import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../components.dart';

class AddAddressButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final void Function() addAddress;
  const AddAddressButton({
    super.key,
    required this.addAddress,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    AddressProvider addressProvider = Provider.of(context);

    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      onPressed: addressProvider.isLoadingCep
          ? null
          : () {
              bool? isValid = formKey.currentState?.validate();

              if (isValid == true) {
                addAddress();
                FocusScope.of(context).unfocus();
              } else {
                ShowSnackbarMessage.show(
                  message:
                      "Insira os dados corretamente para salvar o endereço",
                  context: context,
                );
              }
            },
      child: const Text(
        "Adicionar endereço",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
