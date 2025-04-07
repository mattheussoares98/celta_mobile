import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../providers/providers.dart';

class ConfirmOrUpdateButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController observationController;
  const ConfirmOrUpdateButton({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.observationController,
  });

  Future<void> _addOrUpdateConcurrent({
    required ResearchPricesProvider researchPricesProvider,
    required BuildContext context,
  }) async {
    bool? isValid = formKey.currentState?.validate();
    if (isValid == false) return;

    ShowAlertDialog.show(
        context: context,
        title: researchPricesProvider.selectedConcurrent == null
            ? "Cadastrar concorrente"
            : "Alterar concorrente",
        content: SingleChildScrollView(
          child: Text(
            researchPricesProvider.selectedConcurrent == null
                ? "Deseja realmente cadastrar o concorrente com os dados informados?"
                : "Deseja realmente alterar o concorrente com os dados informados?",
            textAlign: TextAlign.center,
          ),
        ),
        function: () async {
          await researchPricesProvider.addOrUpdateConcurrent(
            context: context,
            concurrentName: nameController.text,
            observation: observationController.text,
          );

          if (researchPricesProvider.errorAddOrUpdateConcurrents == "") {
            nameController.clear();
            observationController.clear();
            Navigator.of(context).pop();
          } else {
            ShowSnackbarMessage.show(
              message: researchPricesProvider.errorAddOrUpdateConcurrents,
              context: context,
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    ResearchPricesProvider researchPricesProvider = Provider.of(context);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(200, 40),
      ),
      onPressed: researchPricesProvider.isLoadingAddOrUpdateConcurrents
          ? null
          : () async {
              await _addOrUpdateConcurrent(
                researchPricesProvider: researchPricesProvider,
                context: context,
              );
            },
      child: Text(
        researchPricesProvider.selectedConcurrent == null
            ? "CADASTRAR"
            : "ALTERAR",
      ),
    );
  }
}
