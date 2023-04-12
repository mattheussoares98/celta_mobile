import 'package:celta_inventario/providers/inventory_product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InsertIndividualProductWidget extends StatefulWidget {
  final bool isIndividual;
  final bool isLoading;
  final Function changeFocus;
  final Function changeValue;
  const InsertIndividualProductWidget({
    required this.isIndividual,
    required this.isLoading,
    required this.changeFocus,
    required this.changeValue,
    Key? key,
  }) : super(key: key);

  @override
  State<InsertIndividualProductWidget> createState() =>
      _InsertIndividualProductWidgetState();
}

class _InsertIndividualProductWidgetState
    extends State<InsertIndividualProductWidget> {
  @override
  Widget build(BuildContext context) {
    InventoryProductProvider inventoryProductProvider = Provider.of(context);
    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            child: TextButton(
              style: TextButton.styleFrom(
                primary: Colors.blue,
              ),
              onPressed: inventoryProductProvider.isLoading ||
                      inventoryProductProvider.isLoadingQuantity
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
                value: widget.isIndividual,
                onChanged: widget.isLoading
                    ? null
                    : (value) {
                        setState(() {
                          widget.changeValue();
                        });
                        if (widget.isIndividual) {
                          widget.changeFocus();
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
