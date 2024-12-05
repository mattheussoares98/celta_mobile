import 'package:flutter/material.dart';

import 'insert_product_without_cadaster.dart';

class ReceiptInsertProductWithoutCadasterPage extends StatefulWidget {
  const ReceiptInsertProductWithoutCadasterPage({super.key});

  @override
  State<ReceiptInsertProductWithoutCadasterPage> createState() =>
      _ReceiptInsertProductWithoutCadasterPageState();
}

class _ReceiptInsertProductWithoutCadasterPageState
    extends State<ReceiptInsertProductWithoutCadasterPage> {
  final formKey = GlobalKey<FormState>();
  final eanController = TextEditingController();
  final observationsController = TextEditingController();
  final quantityController = TextEditingController();
  final eanFocusNode = FocusNode();
  final observationsFocusNode = FocusNode();
  final quantityFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    eanController.dispose();
    observationsController.dispose();
    eanFocusNode.dispose();
    observationsFocusNode.dispose();
    quantityFocusNode.dispose();
    quantityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final docCode = arguments["docCode"];
    // final isInserting = arguments["isInserting"];

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const FittedBox(
            child: Text(
              "Inserir produto sem cadastro",
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                EanField(
                  eanController: eanController,
                  observationsFocusNode: observationsFocusNode,
                ),
                const SizedBox(height: 8),
                ObservationsField(
                  observationsController: observationsController,
                  observationsFocusNode: observationsFocusNode,
                  quantityFocusNode: quantityFocusNode,
                ),
                const SizedBox(height: 8),
                QuantityField(
                  quantityController: quantityController,
                  quantityFocusNode: quantityFocusNode,
                ),
                const SizedBox(height: 8),
                InsertButton(
                  formKey: formKey,
                  docCode: docCode,
                  eanController: eanController,
                  observationsController: observationsController,
                  quantityController: quantityController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
