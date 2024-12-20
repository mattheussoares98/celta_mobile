import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/models.dart';
import '../../../../providers/providers.dart';
import '../../../../utils/utils.dart';
import '../../../../components/components.dart';

class LiberateCheckButtons extends StatefulWidget {
  final ReceiptModel receipt;
  final int index;
  final EnterpriseModel enterprise;
  const LiberateCheckButtons({
    required this.receipt,
    required this.enterprise,
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  State<LiberateCheckButtons> createState() => _LiberateCheckButtonsState();
}

class _LiberateCheckButtonsState extends State<LiberateCheckButtons> {
  @override
  Widget build(BuildContext context) {
    ReceiptProvider receiptProvider = Provider.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              ShowAlertDialog.show(
                context: context,
                title: "Liberar recebimento?",
                content: const SingleChildScrollView(
                  child: Text(
                    "Ao liberar o recebimento, todos recebimentos serão consultados novamente para atualizar os status!",
                    textAlign: TextAlign.center,
                  ),
                ),
                function: () async {
                  await receiptProvider.liberate(
                    grDocCode: widget.receipt.CodigoInterno_ProcRecebDoc,
                    index: widget.index,
                    context: context,
                    enterprise: widget.enterprise,
                  );
                },
              );
            },
            child: const Text("Liberar"),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                APPROUTES.RECEIPT_CONFERENCE,
                arguments: {
                  "grDocCode": widget.receipt.CodigoInterno_ProcRecebDoc,
                  "numeroProcRecebDoc": widget.receipt.Numero_ProcRecebDoc,
                  "emitterName": widget.receipt.EmitterName,
                  "enterprise": widget.enterprise,
                },
              );
            },
            child: const Text("Conferir"),
          ),
        )
      ],
    );
  }
}
