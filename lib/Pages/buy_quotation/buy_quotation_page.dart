import 'package:flutter/material.dart';

class BuyQuotationPage extends StatelessWidget {
  const BuyQuotationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cotação de compras"),
      ),
      body: const Center(child: Text("Cotação de compras")),
    );
  }
}
