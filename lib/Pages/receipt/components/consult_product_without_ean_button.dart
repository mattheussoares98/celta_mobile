import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/enterprise/enterprise.dart';
import '../../../providers/providers.dart';

class ConsultProductWithoutEanButton extends StatefulWidget {
  final int docCode;
  final EnterpriseModel enterprise;
  const ConsultProductWithoutEanButton({
    required this.docCode,
    required this.enterprise,
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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
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
                enterprise: widget.enterprise,
              );
            },
      child: Text(
        receiptProvider.isLoadingProducts ||
                receiptProvider.isLoadingUpdateQuantity
            ? "Aguarde o término da consulta/alteração"
            : "Consultar todos produtos do recebimento",
      ),
    );
  }
}
