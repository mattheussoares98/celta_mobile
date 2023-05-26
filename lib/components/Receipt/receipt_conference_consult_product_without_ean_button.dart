import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/receipt_conference_provider.dart';

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
    ReceiptConferenceProvider receiptConferenceProvider = Provider.of(context);
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primary,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
        ),
        onPressed: receiptConferenceProvider.consultingProducts ||
                receiptConferenceProvider.isUpdatingQuantity
            ? null
            : () async {
                await receiptConferenceProvider.getAllProductsWithoutEan(
                  docCode: widget.docCode,
                  context: context,
                );
              },
        child: Text(
          receiptConferenceProvider.consultingProducts ||
                  receiptConferenceProvider.isUpdatingQuantity
              ? "Aguarde o término da consulta/alteração"
              : "Consultar todos produtos do recebimento",
        ),
      ),
    );
  }
}
