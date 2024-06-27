import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/providers.dart';

class ConsultProductWithoutEanButton extends StatefulWidget {
  final int docCode;
  const ConsultProductWithoutEanButton({
    required this.docCode,
    Key? key,
  }) : super(key: key);

  @override
  State<ConsultProductWithoutEanButton> createState() =>
      _ConsultProductWithoutEanButtonState();
}

class _ConsultProductWithoutEanButtonState
    extends State<ConsultProductWithoutEanButton> {
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
        onPressed: receiptProvider.isLoadingProducts ||
                receiptProvider.isLoadingUpdateQuantity
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
          receiptProvider.isLoadingProducts ||
                  receiptProvider.isLoadingUpdateQuantity
              ? "Aguarde o término da consulta/alteração"
              : "Consultar todos produtos do recebimento",
        ),
      ),
    );
  }
}
