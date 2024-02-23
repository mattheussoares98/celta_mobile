import 'package:flutter/material.dart';

import '../../components/inventory/inventory.dart';

class CountingPage extends StatefulWidget {
  const CountingPage({Key? key}) : super(key: key);

  @override
  State<CountingPage> createState() => _CountingPageState();
}

class _CountingPageState extends State<CountingPage> {
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CONTAGENS',
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: InventoryCountingItems(
              codigoInternoEmpresa: arguments["codigoInternoEmpresa"],
            ),
          ),
        ],
      ),
    );
  }
}
