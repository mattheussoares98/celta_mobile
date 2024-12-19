import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../models/receipt/receipt.dart';
import '../../../../providers/providers.dart';

class Observations extends StatelessWidget {
  final ReceiptModel receipt;
  final TextEditingController observationsController;
  const Observations({
    required this.receipt,
    required this.observationsController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ReceiptProvider receiptProvider = Provider.of(context);

    return TitleAndSubtitle.titleAndSubtitle(
      title: receipt.Observacoes_ProcRecebDoc != null ? "Observações" : null,
      subtitle: receipt.Observacoes_ProcRecebDoc != null
          ? receipt.Observacoes_ProcRecebDoc.toString()
          : "Sem observações",
      otherWidget: TextButton(
        onPressed: () async {
          if (receipt.DefaultObservations != null) {
            observationsController.text = receipt.DefaultObservations!;
            observationsController.text =
                observationsController.text.replaceAll(RegExp(r'\\r'), '');
            observationsController.text =
                observationsController.text.replaceAll(RegExp(r'\\n'), '\n');
          }

          ShowAlertDialog.show(
            context: context,
            title: "Alterar observações",
            confirmMessage: "Alterar",
            cancelMessage: "Cancelar",
            insetPadding: const EdgeInsets.all(1),
            contentPadding: const EdgeInsets.all(3),
            content: TextFormField(
              controller: observationsController,
              maxLines: 10,
              decoration: FormFieldDecoration.decoration(
                context: context,
              ),
            ),
            canCloseClickingOut: false,
            closeAutomaticallyOnConfirm: false,
            function: () async {
              await receiptProvider.updateObservations(
                observations: observationsController.text,
                grDocCode: receipt.CodigoInterno_ProcRecebDoc,
                context: context,
              );
            },
          );
        },
        child: const Text("Alterar"),
      ),
    );
  }
}
