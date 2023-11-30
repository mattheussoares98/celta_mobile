import 'package:celta_inventario/Components/Receipt/receipt_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/Global_widgets/searchAgain.dart';
import '../../components/Global_widgets/searching_widget.dart';
import '../../providers/receipt_provider.dart';

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
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    if (!isLoaded) {
      Provider.of<ReceiptProvider>(context, listen: true).getReceipt(
        enterpriseCode: arguments["CodigoInterno_Empresa"],
        context: context,
      );
    }
    isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    ReceiptProvider receiptProvider = Provider.of(context, listen: true);
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RECEBIMENTOS',
        ),
        actions: [
          IconButton(
            onPressed: receiptProvider.isLoadingReceipt
                ? null
                : () async {
                    await receiptProvider.getReceipt(
                      enterpriseCode: arguments["CodigoInterno_Empresa"],
                      context: context,
                      isSearchingAgain: true,
                    );
                  },
            tooltip: "Consultar recebimentos",
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await receiptProvider.getReceipt(
            enterpriseCode: arguments["CodigoInterno_Empresa"],
            context: context,
            isSearchingAgain: true,
          );
        },
        child: Column(
          children: [
            if (receiptProvider.isLoadingReceipt)
              Expanded(
                child: searchingWidget(title: 'Consultando recebimentos'),
              ),
            if (receiptProvider.errorMessage != '' &&
                receiptProvider.receiptCount == 0 &&
                !receiptProvider.isLoadingReceipt)
              Expanded(
                child: searchAgain(
                    errorMessage: receiptProvider.errorMessage,
                    request: () async {
                      setState(() {});
                      await receiptProvider.getReceipt(
                        enterpriseCode: arguments["CodigoInterno_Empresa"],
                        context: context,
                      );
                    }),
              ),
            if (!receiptProvider.isLoadingReceipt &&
                receiptProvider.errorMessage == '')
              Expanded(
                child: ReceiptItems(
                  enterpriseCode: arguments["CodigoInterno_Empresa"],
                  receiptProvider: receiptProvider,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
