import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/providers.dart';

class InsertIndividualProductSwitch extends StatefulWidget {
  final bool isIndividual;
  final bool isLoading;
  final Function changeValue;
  const InsertIndividualProductSwitch({
    required this.isIndividual,
    required this.isLoading,
    required this.changeValue,
    Key? key,
  }) : super(key: key);

  @override
  State<InsertIndividualProductSwitch> createState() =>
      _InsertIndividualProductSwitchState();
}

class _InsertIndividualProductSwitchState
    extends State<InsertIndividualProductSwitch> {
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
                inactiveTrackColor: Colors.grey[300],
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
