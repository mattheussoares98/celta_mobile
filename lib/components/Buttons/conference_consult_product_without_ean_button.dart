import 'package:flutter/material.dart';
import '../../providers/conference_provider.dart';

class ConferenceConsultProductWithoutEanButton extends StatefulWidget {
  final ConferenceProvider conferenceProvider;
  final int docCode;
  const ConferenceConsultProductWithoutEanButton({
    required this.docCode,
    required this.conferenceProvider,
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
        onPressed: widget.conferenceProvider.consultingProducts ||
                widget.conferenceProvider.isUpdatingQuantity
            ? null
            : () async {
                await widget.conferenceProvider.getAllProductsWithoutEan(
                  docCode: widget.docCode,
                  context: context,
                );
              },
        child: Text(
          widget.conferenceProvider.consultingProducts ||
                  widget.conferenceProvider.isUpdatingQuantity
              ? "Aguarde o término da consulta/alteração"
              : "Consultar todos produtos sem EAN",
        ),
      ),
    );
  }
}
