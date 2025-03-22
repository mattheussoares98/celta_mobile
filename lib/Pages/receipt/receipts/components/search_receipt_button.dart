import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Models/models.dart';
import '../../../../providers/providers.dart';

class SearchReceiptButton extends StatelessWidget {
  final EnterpriseModel enterprise;
  const SearchReceiptButton({
    required this.enterprise,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ReceiptProvider receiptProvider = Provider.of(context);

    return IconButton(
      onPressed: receiptProvider.isLoadingReceipt
          ? null
          : () async {
              await receiptProvider.getReceipt(
                enterpriseCode: enterprise.Code,
                context: context,
                isSearchingAgain: true,
              );
            },
      tooltip: "Consultar recebimentos",
      icon: const Icon(Icons.refresh),
    );
  }
}
