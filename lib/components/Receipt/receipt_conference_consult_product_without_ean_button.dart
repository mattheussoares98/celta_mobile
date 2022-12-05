import 'package:flutter/material.dart';
import '../../providers/receipt_conference_provider.dart';

class ConferenceConsultProductWithoutEanButton extends StatefulWidget {
  final ReceiptConferenceProvider receiptConferenceProvider;
  final int docCode;
  const ConferenceConsultProductWithoutEanButton({
    required this.docCode,
    required this.receiptConferenceProvider,
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
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primary,
      child: TextButton(
        style: TextButton.styleFrom(
          primary: Colors.white,
        ),
        onPressed: widget.receiptConferenceProvider.consultingProducts ||
                widget.receiptConferenceProvider.isUpdatingQuantity
            ? null
            : () async {
                await widget.receiptConferenceProvider.getAllProductsWithoutEan(
                  docCode: widget.docCode,
                  context: context,
                );
              },
        child: Text(
          widget.receiptConferenceProvider.consultingProducts ||
                  widget.receiptConferenceProvider.isUpdatingQuantity
              ? "Aguarde o término da consulta/alteração"
              : "Consultar todos produtos sem EAN",
        ),
      ),
    );
  }
}
