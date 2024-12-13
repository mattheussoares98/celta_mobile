import 'package:flutter/material.dart';

import '../../components/components.dart';

class BuyQuotationPage extends StatefulWidget {
  const BuyQuotationPage({super.key});

  @override
  State<BuyQuotationPage> createState() => _BuyQuotationPageState();
}

class _BuyQuotationPageState extends State<BuyQuotationPage> {
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    searchFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consulta de cotações"),
      ),
      body: Column(
        children: [
          SearchWidget(
            searchProductController: searchController,
            onPressSearch: () {},
            searchFocusNode: searchFocusNode,
          ),
        ],
      ),
    );
  }
}
