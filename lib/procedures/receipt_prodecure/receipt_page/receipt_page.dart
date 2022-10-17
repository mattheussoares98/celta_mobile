import 'package:celta_inventario/procedures/receipt_prodecure/receipt_page/receipt_items.dart';
import 'package:celta_inventario/utils/consulting_widget.dart';
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
  bool _isLoaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    EnterpriseReceiptModel enterprise =
        ModalRoute.of(context)!.settings.arguments as EnterpriseReceiptModel;

    if (!_isLoaded) {
      Provider.of<ReceiptProvider>(context, listen: false).getReceipt(
        enterpriseCode: enterprise.codigoInternoEmpresa.toString(),
        userIdentity: UserIdentity.identity,
      );
      _isLoaded = true;
    }
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
          if (receiptProvider.isLoading)
            Expanded(
                child: ConsultingWidget.consultingWidget(
                    title: 'Consultando recebimentos')),
          if (receiptProvider.errorMessage != '')
            Expanded(
              child: TryAgainWidget.tryAgain(
                provider: receiptProvider,
                errorMessage: receiptProvider.errorMessage,
                request: () async => setState(() {
                  receiptProvider.getReceipt(
                    enterpriseCode: enterprise.codigoInternoEmpresa.toString(),
                    userIdentity: UserIdentity.identity,
                  );
                }),
              ),
            ),
          if (receiptProvider.errorMessage == "" && !receiptProvider.isLoading)
            const Expanded(child: const ReceiptItems()),
        ],
      ),
    );
  }
}
