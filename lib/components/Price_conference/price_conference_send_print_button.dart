import 'package:celta_inventario/providers/price_conference_provider.dart';
import 'package:flutter/material.dart';

class PriceConferenceSendPrintButton extends StatefulWidget {
  final bool etiquetaPendente;
  final PriceConferenceProvider priceConferenceProvider;
  final int internalEnterpriseCode;
  final int productPackingCode;
  final int index;
  const PriceConferenceSendPrintButton({
    required this.internalEnterpriseCode,
    required this.index,
    required this.priceConferenceProvider,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            primary: widget.etiquetaPendente == false
                ? Theme.of(context).colorScheme.primary
                : Colors.red,
          ),
          onPressed: widget.priceConferenceProvider.isSendingToPrint
              ? null
              : () async {
                  await widget.priceConferenceProvider.sendToPrint(
                    enterpriseCode: widget.internalEnterpriseCode,
                    productPackingCode: widget.productPackingCode,
                    index: widget.index,
                    context: context,
                  );
                },
          child: widget.priceConferenceProvider.isSendingToPrint ||
                  widget.priceConferenceProvider.isLoading
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
