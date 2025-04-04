import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../Models/models.dart';
import '../../../providers/providers.dart';

class SaveButton extends StatelessWidget {
  final bool isInserting;
  final TextEditingController observationsController;
  final EnterpriseModel? enterpriseModel;
  const SaveButton({
    required this.isInserting,
    required this.observationsController,
    required this.enterpriseModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    BuyQuotationProvider buyQuotationProvider = Provider.of(context);

    return IconButton(
      onPressed: () async {
        if (buyQuotationProvider.allEnterprises.isEmpty) {
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
                observationsController: observationsController,
              );

              if (updated) {
                if (enterpriseModel != null) {
                  await buyQuotationProvider.getBuyQuotation(
                    context: context,
                    valueToSearch: "%",
                    searchByPersonalizedCode: false,
                    enterpriseCode: enterpriseModel!.Code,
                  );
                }
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
