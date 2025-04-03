import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../components.dart';

class AddAddressButton extends StatelessWidget {
  final bool Function() validateAdressFormKey;
  const AddAddressButton({
    super.key,
    required this.validateAdressFormKey,
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
              bool isValid = validateAdressFormKey();

              if (isValid && addressProvider.cepController.text.isNotEmpty) {
                addressProvider.addAddress();
                if (addressProvider.errorMessageAddAddres != "") {
                  ShowSnackbarMessage.show(
                    message: addressProvider.errorMessageAddAddres,
                    context: context,
                  );
                }
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
