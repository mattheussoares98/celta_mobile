import 'package:celta_inventario/procedures/consult_price_procedure/consult_price_page/consult_price_provider.dart';
import 'package:celta_inventario/utils/show_error_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ConsultPriceSendPrintButton extends StatefulWidget {
  final String etiquetaPendenteDescricao;
  final ConsultPriceProvider consultPriceProvider;
  final int internalEnterpriseCode;
  final int productPackingCode;
  final int index;
  const ConsultPriceSendPrintButton({
    required this.internalEnterpriseCode,
    required this.index,
    required this.consultPriceProvider,
    required this.productPackingCode,
    required this.etiquetaPendenteDescricao,
    Key? key,
  }) : super(key: key);

  @override
  State<ConsultPriceSendPrintButton> createState() =>
      _ConsultPriceSendPrintButtonState();
}

class _ConsultPriceSendPrintButtonState
    extends State<ConsultPriceSendPrintButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: widget.etiquetaPendenteDescricao == "Não"
            ? Theme.of(context).colorScheme.primary
            : Colors.red,
      ),
      onPressed: widget.consultPriceProvider.isSendingToPrint
          ? null
          : () async {
              await widget.consultPriceProvider.sendToPrint(
                enterpriseCode: widget.internalEnterpriseCode,
                productPackingCode: widget.productPackingCode,
                index: widget.index,
              );

              if (widget.consultPriceProvider.errorSendToPrint != "") {
                ShowErrorMessage().showErrorMessage(
                  error: widget.consultPriceProvider.errorSendToPrint,
                  context: context,
                );
              }
            },
      child: widget.consultPriceProvider.isSendingToPrint ||
              widget.consultPriceProvider.isLoading
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
                Text(widget.etiquetaPendenteDescricao == "Sim"
                    ? "Desmarcar para impressão  "
                    : "Marcar para impressão  "),
                Icon(
                  widget.etiquetaPendenteDescricao == "Sim"
                      ? Icons.print_disabled
                      : Icons.print,
                )
              ],
            ),
    );
  }
}
