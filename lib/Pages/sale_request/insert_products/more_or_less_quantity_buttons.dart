import 'package:flutter/material.dart';

import '../../../utils/utils.dart';

class MoreOrLessQuantityButtons extends StatefulWidget {
  final TextEditingController productQuantityController;
  final void Function() updateTotalItemValue;
  const MoreOrLessQuantityButtons({
    required this.productQuantityController,
    required this.updateTotalItemValue,
    super.key,
  });

  @override
  State<MoreOrLessQuantityButtons> createState() =>
      _MoreOrLessQuantityButtonsState();
}

class _MoreOrLessQuantityButtonsState extends State<MoreOrLessQuantityButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          color: Theme.of(context).colorScheme.primary,
          onPressed: () {
            double quantityToAdd =
                widget.productQuantityController.text.toDouble();
    
            setState(() {
              if (quantityToAdd <= 1) {
                widget.productQuantityController.text = "";
                widget.productQuantityController.clear();
              } else {
                quantityToAdd = quantityToAdd - 1;
                widget.productQuantityController.text = quantityToAdd
                    .toStringAsFixed(3)
                    .replaceAll(RegExp(r'\.'), ',');
              }
    
              widget.updateTotalItemValue();
            });
          },
          icon: Icon(
            Icons.remove,
            color: widget.productQuantityController.text.isEmpty
                ? Colors.grey
                : Theme.of(context).colorScheme.primary,
          ),
        ),
        IconButton(
          color: Theme.of(context).colorScheme.primary,
          onPressed: () {
            if (widget.productQuantityController.text.isEmpty ||
                widget.productQuantityController.text == "0") {
              widget.productQuantityController.text = "1,000";
              widget.updateTotalItemValue();
            } else {
              double? parsedQuantity = double.tryParse(widget
                  .productQuantityController.text
                  .replaceAll(RegExp(r','), '.'));
    
              if (parsedQuantity != null) {
                parsedQuantity++;
    
                widget.productQuantityController.text = parsedQuantity
                    .toStringAsFixed(3)
                    .replaceAll(RegExp(r'\.'), ',');
              }
              widget.updateTotalItemValue();
            }
          },
          icon: const Icon(
            Icons.add,
          ),
        ),
      ],
    );
  }
}
