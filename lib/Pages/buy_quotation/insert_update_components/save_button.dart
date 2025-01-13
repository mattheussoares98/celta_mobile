import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../providers/providers.dart';

class SaveButton extends StatelessWidget {
  final bool isInserting;
  final TextEditingController observationsController;
  const SaveButton({
    required this.isInserting,
    required this.observationsController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    BuyQuotationProvider buyQuotationProvider = Provider.of(context);

    return IconButton(
      onPressed: () async {
        if (buyQuotationProvider.selectedEnterprises.isEmpty) {
          ShowSnackbarMessage.show(
            message: "Selecione pelo menos uma empresa!",
            context: context,
          );
          return;
        }
        ShowAlertDialog.show(
            context: context,
            title: "Salvar?",
            function: () async {
              bool updated =
                  await buyQuotationProvider.insertUpdateBuyQuotation(
                isInserting: isInserting,
                observations: observationsController.text.isNotEmpty
                    ? observationsController.text
                    : null,
                dateOfCreation:
                    buyQuotationProvider.completeBuyQuotation?.DateOfCreation,
                dateOfLimit:
                    buyQuotationProvider.completeBuyQuotation?.DateOfLimit,
              );

              if (updated) {
                Navigator.of(context).pop();
              }
            });
      },
      icon: const Icon(
        Icons.save,
      ),
    );
  }
}
