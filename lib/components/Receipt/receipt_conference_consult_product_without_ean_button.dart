import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';

class ConferenceConsultProductWithoutEanButton extends StatefulWidget {
  final int docCode;
  const ConferenceConsultProductWithoutEanButton({
    required this.docCode,
    Key? key,
  }) : super(key: key);

  @override
  State<ConferenceConsultProductWithoutEanButton> createState() =>
      _ConferenceConsultProductWithoutEanButtonState();
}

class _ConferenceConsultProductWithoutEanButtonState
    extends State<ConferenceConsultProductWithoutEanButton> {
  @override
  Widget build(BuildContext context) {
    ReceiptProvider receiptProvider = Provider.of(context);
    ConfigurationsProvider configurationsProvider = Provider.of(context);
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primary,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
        ),
        onPressed: receiptProvider.consultingProducts ||
                receiptProvider.isUpdatingQuantity
            ? null
            : () async {
                await receiptProvider.getProducts(
                  docCode: widget.docCode,
                  context: context,
                  controllerText: "",
                  isSearchAllCountedProducts: true,
                  configurationsProvider: configurationsProvider,
                );
              },
        child: Text(
          receiptProvider.consultingProducts ||
                  receiptProvider.isUpdatingQuantity
              ? "Aguarde o término da consulta/alteração"
              : "Consultar todos produtos do recebimento",
        ),
      ),
    );
  }
}
