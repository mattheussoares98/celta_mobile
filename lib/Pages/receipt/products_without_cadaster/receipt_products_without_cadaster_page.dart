import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../providers/providers.dart';
import 'components/components.dart';

class ReceiptProductsWithoutCadasterPage extends StatefulWidget {
  const ReceiptProductsWithoutCadasterPage({super.key});

  @override
  State<ReceiptProductsWithoutCadasterPage> createState() =>
      _ReceiptProductsWithoutCadasterPageState();
}

class _ReceiptProductsWithoutCadasterPageState
    extends State<ReceiptProductsWithoutCadasterPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        int docCode = ModalRoute.of(context)!.settings.arguments as int;
        ReceiptProvider receiptProvider = Provider.of(context, listen: false);
        await receiptProvider.getProductWithoutCadaster(docCode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ReceiptProvider receiptProvider = Provider.of(context);
    int docCode = ModalRoute.of(context)!.settings.arguments as int;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const FittedBox(child: Text("Produtos não encontrados")),
          ),
          body: Column(
            children: [
              InsertNotFoundProductButton(docCode: docCode),
              const Expanded(child: Text("")),
            ],
          ),
        ),
        loadingWidget(receiptProvider.isLoadingProductsWithoutCadaster),
      ],
    );
  }
}
