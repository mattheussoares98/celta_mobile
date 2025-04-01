import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';

import '../../../../Models/models.dart';
import '../../../../providers/providers.dart';

class Observations extends StatelessWidget {
  final ReceiptModel receipt;
  final TextEditingController observationsController;
  final EnterpriseModel enterprise;
  final bool showObservationsField;
  final void Function() updateShowObservationsField;
  const Observations({
    required this.receipt,
    required this.observationsController,
    required this.enterprise,
    required this.showObservationsField,
    required this.updateShowObservationsField,
    super.key,
  });

  String? observationsWithoutBar(
    String? value, {
    required bool breakLineInStart,
  }) {
    String? newValue = value;
    newValue = newValue?.replaceAll(RegExp(r'\\r\\'), '');
    newValue = newValue?.replaceAll(RegExp(r'\\n'), '\n');
    newValue = newValue?.replaceAll(RegExp(r'\\'), '');

    if (breakLineInStart) {
      newValue = "\n$newValue";
    }
    return newValue;
  }

  @override
  Widget build(BuildContext context) {
    ReceiptProvider receiptProvider = Provider.of(context);

    return Column(
      children: [
        TitleAndSubtitle.titleAndSubtitle(
          title: observationsWithoutBar(
                    receipt.Observacoes_ProcRecebDoc != null
                        ? receipt.Observacoes_ProcRecebDoc
                        : receipt.DefaultObservations,
                    breakLineInStart: false,
                  ) ==
                  null
              ? null
              : "Observações",
          subtitle: observationsWithoutBar(
                    receipt.Observacoes_ProcRecebDoc != null
                        ? receipt.Observacoes_ProcRecebDoc
                        : receipt.DefaultObservations,
                    breakLineInStart: false,
                  ) ==
                  null
              ? "Sem observações"
              : observationsWithoutBar(
                  receipt.Observacoes_ProcRecebDoc != null
                      ? receipt.Observacoes_ProcRecebDoc
                      : receipt.DefaultObservations,
                  breakLineInStart: true,
                ),
          otherWidget: TextButton(
            onPressed: () async {
              if (receipt.Observacoes_ProcRecebDoc != null &&
                  receipt.Observacoes_ProcRecebDoc!.isNotEmpty) {
                observationsController.text = observationsWithoutBar(
                      receipt.Observacoes_ProcRecebDoc,
                      breakLineInStart: false,
                    ) ??
                    "";
              } else if (receipt.DefaultObservations != null) {
                observationsController.text = observationsWithoutBar(
                      receipt.DefaultObservations,
                      breakLineInStart: false,
                    ) ??
                    "";
              }

              updateShowObservationsField();
            },
            child: const Text("Alterar\nobs", textAlign: TextAlign.center),
          ),
        ),
        if (showObservationsField)
          Column(
            children: [
              TextFormField(
                controller: observationsController,
                maxLines: null,
                minLines: 1,
                style: const TextStyle(
                  fontSize: 14,
                ),
                decoration: FormFieldDecoration.decoration(
                  context: context,
                ),
              ),
              TextButton(
                onPressed: observationsController.text.isEmpty
                    ? null
                    : () async {
                        ShowAlertDialog.show(
                            context: context,
                            title: "",
                            content: const Text(
                              "Deseja realmente alterar a observação?",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            function: () async {
                              await receiptProvider.updateObservations(
                                observations: observationsController.text,
                                receipt: receipt,
                                enterprise: enterprise,
                              );
                            });
                      },
                child: const Text("Confirmar observação"),
              ),
            ],
          ),
      ],
    );
  }
}
