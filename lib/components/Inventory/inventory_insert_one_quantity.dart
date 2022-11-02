import 'package:celta_inventario/providers/inventory_product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InsertOneQuantity extends StatefulWidget {
  final bool isIndividual;
  final int codigoInternoInvCont;
  final TextEditingController consultedProductController;
  const InsertOneQuantity({
    Key? key,
    required this.isIndividual,
    required this.codigoInternoInvCont,
    required this.consultedProductController,
  }) : super(key: key);

  @override
  State<InsertOneQuantity> createState() => _InsertOneQuantityState();
}

class _InsertOneQuantityState extends State<InsertOneQuantity> {
  @override
  Widget build(BuildContext context) {
    InventoryProductProvider inventoryProductProvider =
        Provider.of(context, listen: true);

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
                inventoryProductProvider.isLoadingQuantity
                    ? "Subtraindo unidade"
                    : "Subtrair 1",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            ),
            onPressed: inventoryProductProvider.isLoadingQuantity
                ? null
                : () {
                    inventoryProductProvider.addQuantity(
                      isIndividual: widget.isIndividual,
                      context: context,
                      codigoInternoInvCont: widget.codigoInternoInvCont,
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
                inventoryProductProvider.isLoadingQuantity
                    ? "Inserindo unidade"
                    : "Adicionar 1",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            ),
            onPressed: inventoryProductProvider.isLoadingQuantity
                ? null
                : () async {
                    await inventoryProductProvider.addQuantity(
                      isIndividual: widget.isIndividual,
                      context: context,
                      codigoInternoInvCont: widget.codigoInternoInvCont,
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
