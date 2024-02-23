import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';

class InsertOneQuantity extends StatefulWidget {
  final bool isIndividual;
  final int inventoryCountingCode;
  final int indexOfProduct;
  final TextEditingController consultedProductController;
  final Function addQuantity;
  final Function subtractQuantity;
  const InsertOneQuantity({
    Key? key,
    required this.subtractQuantity,
    required this.addQuantity,
    required this.isIndividual,
    required this.indexOfProduct,
    required this.inventoryCountingCode,
    required this.consultedProductController,
  }) : super(key: key);

  @override
  State<InsertOneQuantity> createState() => _InsertOneQuantityState();
}

class _InsertOneQuantityState extends State<InsertOneQuantity> {
  @override
  Widget build(BuildContext context) {
    InventoryProvider inventoryProvider = Provider.of(context, listen: true);

    return Padding(
      padding: const EdgeInsets.only(right: 8.0, bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 3,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 70),
                maximumSize: const Size(double.infinity, 70),
              ),
              child: FittedBox(
                child: Text(
                  inventoryProvider.isLoadingQuantity
                      ? "Subtraindo unidade"
                      : "Subtrair 1",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
              onPressed: inventoryProvider.isLoadingQuantity
                  ? null
                  : () async {
                      await widget.subtractQuantity();
                    },
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            flex: 6,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 70),
                maximumSize: const Size(double.infinity, 70),
              ),
              child: FittedBox(
                child: Text(
                  inventoryProvider.isLoadingQuantity
                      ? "Inserindo unidade"
                      : "Adicionar 1",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
              onPressed: inventoryProvider.isLoadingQuantity
                  ? null
                  : () async {
                      await widget.addQuantity();
                    },
            ),
          ),
        ],
      ),
    );
  }
}
