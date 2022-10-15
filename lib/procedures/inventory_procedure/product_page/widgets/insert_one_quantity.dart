import 'package:celta_inventario/procedures/inventory_procedure/provider/quantity_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/add_quantity_controller.dart';

class InsertOneQuantity extends StatefulWidget {
  final bool isIndividual;
  final int countingCode;
  final TextEditingController consultedProductController;
  const InsertOneQuantity({
    Key? key,
    required this.isIndividual,
    required this.countingCode,
    required this.consultedProductController,
  }) : super(key: key);

  @override
  State<InsertOneQuantity> createState() => _InsertOneQuantityState();
}

class _InsertOneQuantityState extends State<InsertOneQuantity> {
  @override
  Widget build(BuildContext context) {
    QuantityProvider quantityProvider = Provider.of(context, listen: true);

    return Row(
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
                quantityProvider.isLoadingQuantity
                    ? "Subtraindo unidade"
                    : "Subtrair 1",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            ),
            onPressed: quantityProvider.isLoadingQuantity
                ? null
                : () {
                    AddQuantityController.addQuantity(
                      isIndividual: widget.isIndividual,
                      context: context,
                      countingCode: widget.countingCode,
                      quantity: widget.consultedProductController,
                      isSubtract: true,
                    );
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
                quantityProvider.isLoadingQuantity
                    ? "Inserindo unidade"
                    : "Adicionar 1",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            ),
            onPressed: quantityProvider.isLoadingQuantity
                ? null
                : () {
                    AddQuantityController.addQuantity(
                      isIndividual: widget.isIndividual,
                      context: context,
                      countingCode: widget.countingCode,
                      quantity: widget.consultedProductController,
                      isSubtract: false,
                    );
                  },
          ),
        ),
      ],
    );
  }
}
