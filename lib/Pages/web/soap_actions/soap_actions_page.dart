import 'package:flutter/material.dart';

class SoapActionsPage extends StatelessWidget {
  const SoapActionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Requisições",
        ),
      ),
      body: Center(
        child: TextButton(
          onPressed: () async {},
          child: const Text("Carregar dados"),
        ),
      ),
    );
  }
}
