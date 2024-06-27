import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
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
                  if (receiptProvider.errorMessage != '' &&
                      receiptProvider.receiptCount == 0 &&
                      !receiptProvider.isLoadingReceipt)
                    Expanded(
                      child: searchAgain(
                          errorMessage: receiptProvider.errorMessage,
                          request: () async {
                            setState(() {});
                            await receiptProvider.getReceipt(
                              enterpriseCode:
                                  arguments["CodigoInterno_Empresa"],
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
          ),
        ),
        loadingWidget(
          message: 'Consultando recebimentos...',
          isLoading: receiptProvider.isLoadingReceipt,
        ),
        loadingWidget(
          message: 'Liberando documento...',
          isLoading: receiptProvider.isLoadingLiberateCheck,
        ),
      ],
    );
  }
}
