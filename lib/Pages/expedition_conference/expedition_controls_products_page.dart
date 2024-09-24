import 'package:flutter/material.dart';

class ExpeditionControlsProductsPage extends StatelessWidget {
  const ExpeditionControlsProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (_, __) {},
      child: Scaffold(
        appBar: AppBar(
          title: const FittedBox(child: Text("Conferência de produtos")),
        ),
        body: const Center(
          child: Text("Conferência de produtos"),
        ),
      ),
    );
  }
}
