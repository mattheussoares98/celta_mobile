import 'package:celta_inventario/procedures/receipt_prodecure/receipt_page/receipt_items.dart';
import 'package:celta_inventario/utils/consulting_widget.dart';
import 'package:celta_inventario/utils/show_error_message.dart';
import 'package:celta_inventario/utils/try_again.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/enterprise_receipt_model.dart';
import 'receipt_provider.dart';

class ReceiptPage extends StatefulWidget {
  const ReceiptPage({Key? key}) : super(key: key);

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  bool isLoaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final enterprise =
        ModalRoute.of(context)!.settings.arguments as EnterpriseReceiptModel;
    if (!isLoaded) {
      Provider.of<ReceiptProvider>(context, listen: true).getReceipt(
        enterpriseCode: enterprise.codigoInternoEmpresa.toString(),
      );
    }
    isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    ReceiptProvider receiptProvider = Provider.of(context, listen: true);
    EnterpriseReceiptModel enterprise =
        ModalRoute.of(context)!.settings.arguments as EnterpriseReceiptModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RECEBIMENTOS',
        ),
      ),
      body: Column(
        children: [
          if (receiptProvider.isLoadingReceipt)
            Expanded(
              child: ConsultingWidget.consultingWidget(
                  title: 'Consultando recebimentos'),
            ),
          if (receiptProvider.errorMessage != '' &&
              receiptProvider.receiptCount == 0 &&
              !receiptProvider.isLoadingReceipt)
            Expanded(
              child: TryAgainWidget.tryAgain(
                  errorMessage: receiptProvider.errorMessage,
                  request: () async {
                    setState(() {});
                    await receiptProvider.getReceipt(
                      enterpriseCode:
                          enterprise.codigoInternoEmpresa.toString(),
                    );
                  }),
            ),
          if (!receiptProvider.isLoadingReceipt &&
              receiptProvider.errorMessage == '')
            Expanded(
              child: ReceiptItems(
                enterprise: enterprise,
                receiptProvider: receiptProvider,
              ),
            ),
        ],
      ),
    );
  }
}
