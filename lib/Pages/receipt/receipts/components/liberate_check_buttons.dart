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
        ElevatedButton(
          onPressed: widget.receiptProvider.isLoadingLiberateCheck
              ? null
              : () async {
                  ShowAlertDialog.show(
                    context: context,
                    title: "Liberar recebimento?",
                    subtitle:
                        "Ao liberar o recebimento, todos recebimentos serão consultados novamente para atualizar os status!",
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
          child: widget.receiptProvider.isLoadingLiberateCheck
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'AGUARDE...',
                    ),
                    const SizedBox(width: 7),
                    Container(
                      height: 20,
                      width: 20,
                      child: const CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
              : const Text("Liberar"),
        ),
        ElevatedButton(
          onPressed: widget.receiptProvider.isLoadingLiberateCheck
              ? null
              : () {
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
          child: widget.receiptProvider.isLoadingLiberateCheck
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'AGUARDE...',
                    ),
                    const SizedBox(width: 7),
                    Container(
                      height: 20,
                      width: 20,
                      child: const CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
              : const Text("Conferir"),
        )
      ],
    );
  }
}
