import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../global_widgets/global_widgets.dart';

class PriceConferenceSendPrintButton extends StatefulWidget {
  final bool etiquetaPendente;
  final int internalEnterpriseCode;
  final int productPackingCode;
  final int index;
  const PriceConferenceSendPrintButton({
    required this.internalEnterpriseCode,
    required this.index,
    required this.productPackingCode,
    required this.etiquetaPendente,
    Key? key,
  }) : super(key: key);

  @override
  State<PriceConferenceSendPrintButton> createState() =>
      _PriceConferenceSendPrintButtonState();
}

class _PriceConferenceSendPrintButtonState
    extends State<PriceConferenceSendPrintButton> {
  @override
  Widget build(BuildContext context) {
    PriceConferenceProvider priceConferenceProvider = Provider.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: widget.etiquetaPendente == false
                ? Theme.of(context).colorScheme.primary
                : Colors.red,
          ),
          onPressed: priceConferenceProvider.isSendingToPrint
              ? null
              : () async {
                  await priceConferenceProvider.sendToPrint(
                    enterpriseCode: widget.internalEnterpriseCode,
                    productPackingCode: widget.productPackingCode,
                    index: widget.index,
                    context: context,
                  );

                  if (priceConferenceProvider.errorSendToPrint != "") {
                    ShowSnackbarMessage.showMessage(
                      message: priceConferenceProvider.errorSendToPrint,
                      context: context,
                    );
                  }
                },
          child: priceConferenceProvider.isSendingToPrint ||
                  priceConferenceProvider.isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text("Aguarde...    "),
                    Container(
                      width: 20,
                      height: 20,
                      child: const CircularProgressIndicator(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(widget.etiquetaPendente == true
                        ? "Desmarcar para impressão  "
                        : "Marcar para impressão  "),
                    Icon(
                      widget.etiquetaPendente == true
                          ? Icons.print_disabled
                          : Icons.print,
                    )
                  ],
                ),
        ),
      ],
    );
  }
}
