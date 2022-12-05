import 'package:celta_inventario/Models/enterprise_models/enterprise_model.dart';
import 'package:celta_inventario/Components/Receipt/receipt_items.dart';
import 'package:celta_inventario/utils/consulting_widget.dart';
import 'package:celta_inventario/utils/try_again.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/receipt_provider.dart';

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
    int enterpriseCode = ModalRoute.of(context)!.settings.arguments as int;
    if (!isLoaded) {
      Provider.of<ReceiptProvider>(context, listen: true).getReceipt(
        enterpriseCode: enterpriseCode,
        context: context,
      );
    }
    isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    ReceiptProvider receiptProvider = Provider.of(context, listen: true);
    int enterpriseCode = ModalRoute.of(context)!.settings.arguments as int;

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
                      enterpriseCode: enterpriseCode,
                      context: context,
                    );
                  }),
            ),
          if (!receiptProvider.isLoadingReceipt &&
              receiptProvider.errorMessage == '')
            Expanded(
              child: ReceiptItems(
                enterpriseCode: enterpriseCode,
                receiptProvider: receiptProvider,
              ),
            ),
        ],
      ),
    );
  }
}
