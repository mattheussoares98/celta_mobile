import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../providers/providers.dart';

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

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const FittedBox(child: Text("Produtos não encontrados")),
          ),
          body: const Center(
            child: Text(
              "Produtos não encontrados",
              //TODO show not found products when the list is empty
            ),
          ),
        ),
        loadingWidget(receiptProvider.isLoadingProductsWithoutCadaster),
      ],
    );
  }
}
