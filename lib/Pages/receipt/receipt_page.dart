import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../models/enterprise/enterprise.dart';
import 'components/components.dart';
import '../../providers/providers.dart';

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
    EnterpriseModel enterprise =
        ModalRoute.of(context)!.settings.arguments as EnterpriseModel;
    if (!isLoaded) {
      Provider.of<ReceiptProvider>(context, listen: true).getReceipt(
        enterpriseCode: enterprise.Code,
        context: context,
      );
    }
    isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    ReceiptProvider receiptProvider = Provider.of(context, listen: true);
    EnterpriseModel enterprise =
        ModalRoute.of(context)!.settings.arguments as EnterpriseModel;

    return Stack(
      children: [
        PopScope(
          canPop: !receiptProvider.isLoadingLiberateCheck,
          child: Scaffold(
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
                            enterpriseCode: enterprise.Code,
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
                  enterpriseCode: enterprise.Code,
                  context: context,
                  isSearchingAgain: true,
                );
              },
              child: Column(
                children: [
                  if (receiptProvider.errorMessage != '' &&
                      receiptProvider.receiptCount == 0 &&
                      !receiptProvider.isLoadingReceipt)
                    Expanded(
                      child: searchAgain(
                          errorMessage: receiptProvider.errorMessage,
                          request: () async {
                            setState(() {});
                            await receiptProvider.getReceipt(
                              enterpriseCode: enterprise.Code,
                              context: context,
                            );
                          }),
                    ),
                  if (!receiptProvider.isLoadingReceipt &&
                      receiptProvider.errorMessage == '')
                    Expanded(
                      child: ReceiptItems(
                        enterpriseCode: enterprise.Code,
                        receiptProvider: receiptProvider,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        loadingWidget(receiptProvider.isLoadingReceipt),
        loadingWidget(receiptProvider.isLoadingLiberateCheck),
      ],
    );
  }
}
