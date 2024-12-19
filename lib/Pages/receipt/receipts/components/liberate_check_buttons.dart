import 'package:flutter/material.dart';

import '../../../../models/enterprise/enterprise.dart';
import '../../../../providers/providers.dart';
import '../../../../utils/utils.dart';
import '../../../../components/components.dart';

class LiberateCheckButtons extends StatefulWidget {
  final int grDocCode;
  final ReceiptProvider receiptProvider;
  final int index;
  final String emitterName;
  final String numeroProcRecebDoc;
  final EnterpriseModel enterprise;
  const LiberateCheckButtons({
    required this.grDocCode,
    required this.enterprise,
    required this.emitterName,
    required this.numeroProcRecebDoc,
    required this.receiptProvider,
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  State<LiberateCheckButtons> createState() => _LiberateCheckButtonsState();
}

class _LiberateCheckButtonsState extends State<LiberateCheckButtons> {
  @override
  Widget build(BuildContext context) {
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
                  await widget.receiptProvider.liberate(
                    grDocCode: widget.grDocCode,
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
                  "grDocCode": widget.grDocCode,
                  "numeroProcRecebDoc": widget.numeroProcRecebDoc,
                  "emitterName": widget.emitterName,
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
