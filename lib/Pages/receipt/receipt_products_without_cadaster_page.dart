import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        ReceiptProvider receiptProvider = Provider.of(context, listen: false);
        await receiptProvider.getProductWithoutCadaster(
          grDocCode: 1, //TODO obtain the code by arguments
          context: context,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(child: Text("Produtos não encontrados")),
      ),
      body: const Center(
        child: Text(
          "Produtos não encontrador",
        ),
      ),
    );
  }
}
