import 'package:celta_inventario/providers/inventory_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InventoryInsertIndividualProductSwitch extends StatefulWidget {
  final bool isIndividual;
  final bool isLoading;
  final Function changeValue;
  const InventoryInsertIndividualProductSwitch({
    required this.isIndividual,
    required this.isLoading,
    required this.changeValue,
    Key? key,
  }) : super(key: key);

  @override
  State<InventoryInsertIndividualProductSwitch> createState() =>
      _InventoryInsertIndividualProductSwitchState();
}

class _InventoryInsertIndividualProductSwitchState
    extends State<InventoryInsertIndividualProductSwitch> {
  @override
  Widget build(BuildContext context) {
    InventoryProvider inventoryProvider = Provider.of(context);
    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
              onPressed: inventoryProvider.isLoadingProducts ||
                      inventoryProvider.isLoadingQuantity
                  ? null
                  : () {
                      setState(() {
                        widget.changeValue();
                      });
                    },
              child: const Text('Inserir produto individualmente',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 30,
                  )),
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: 100,
            height: 70,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Switch(
                activeColor: Colors.blue,
                inactiveThumbColor: Colors.grey,
                value: widget.isIndividual,
                onChanged: widget.isLoading
                    ? null
                    : (value) {
                        setState(() {
                          widget.changeValue();
                        });
                        if (widget.isIndividual) {
                          inventoryProvider.alterFocusToConsultProduct(
                            context: context,
                          );
                        }
                      },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
