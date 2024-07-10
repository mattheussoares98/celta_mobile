import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/providers.dart';
import '../../../components/components.dart';

class SendToPrintButton extends StatelessWidget {
  final bool etiquetaPendente;
  final int internalEnterpriseCode;
  final int productPackingCode;
  final int index;
  const SendToPrintButton({
    required this.internalEnterpriseCode,
    required this.index,
    required this.productPackingCode,
    required this.etiquetaPendente,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PriceConferenceProvider priceConferenceProvider = Provider.of(context);
    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: etiquetaPendente
            ? Colors.red
            : Theme.of(context).colorScheme.primary,
      ),
      onPressed: priceConferenceProvider.isSendingToPrint
          ? null
          : () async {
              await priceConferenceProvider.sendToPrint(
                enterpriseCode: internalEnterpriseCode,
                productPackingCode: productPackingCode,
                index: index,
                context: context,
              );
    
              if (priceConferenceProvider.errorSendToPrint != "") {
                ShowSnackbarMessage.showMessage(
                  message: priceConferenceProvider.errorSendToPrint,
                  context: context,
                );
              }
            },
      icon: Icon(
        etiquetaPendente == true ? Icons.print_disabled : Icons.print,
      ),
      iconAlignment: IconAlignment.end,
      label: Text(etiquetaPendente == true
          ? "Desmarcar para impressão"
          : "Marcar para impressão"),
    );
  }
}
