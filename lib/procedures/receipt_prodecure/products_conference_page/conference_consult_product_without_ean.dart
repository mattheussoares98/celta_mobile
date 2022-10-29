import 'package:celta_inventario/utils/show_error_message.dart';
import 'package:flutter/material.dart';

import 'conference_provider.dart';

class ConferenceConsultProductWithoutEan extends StatefulWidget {
  final ConferenceProvider conferenceProvider;
  final int docCode;
  const ConferenceConsultProductWithoutEan({
    required this.docCode,
    required this.conferenceProvider,
    Key? key,
  }) : super(key: key);

  @override
  State<ConferenceConsultProductWithoutEan> createState() =>
      _ConferenceConsultProductWithoutEanState();
}

class _ConferenceConsultProductWithoutEanState
    extends State<ConferenceConsultProductWithoutEan> {
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
                );

                if (widget.conferenceProvider.errorMessageGetProducts != "") {
                  ShowErrorMessage().showErrorMessage(
                    error: widget.conferenceProvider.errorMessageGetProducts,
                    context: context,
                  );
                }
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
