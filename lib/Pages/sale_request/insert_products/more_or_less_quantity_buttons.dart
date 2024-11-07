import 'package:flutter/material.dart';

import '../../../utils/utils.dart';

class MoreOrLessQuantityButtons extends StatefulWidget {
  final TextEditingController newQuantityController;
  final void Function() updateTotalItemValue;
  const MoreOrLessQuantityButtons({
    required this.newQuantityController,
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
            double quantityToAdd = widget.newQuantityController.text.toDouble();

            setState(() {
              if (quantityToAdd <= 1) {
                widget.newQuantityController.text = "";
                widget.newQuantityController.clear();
              } else {
                quantityToAdd = quantityToAdd - 1;
                widget.newQuantityController.text = quantityToAdd
                    .toStringAsFixed(3)
                    .replaceAll(RegExp(r'\.'), ',');
              }

              widget.updateTotalItemValue();
            });
          },
          icon: Icon(
            Icons.remove,
            color: widget.newQuantityController.text.isEmpty
                ? Colors.grey
                : Theme.of(context).colorScheme.primary,
          ),
        ),
        IconButton(
          color: Theme.of(context).colorScheme.primary,
          onPressed: () {
            if (widget.newQuantityController.text.isEmpty ||
                widget.newQuantityController.text == "0") {
              widget.newQuantityController.text = "1,000";
              widget.updateTotalItemValue();
            } else {
              double? parsedQuantity = double.tryParse(widget
                  .newQuantityController.text
                  .replaceAll(RegExp(r','), '.'));

              if (parsedQuantity != null) {
                parsedQuantity++;

                widget.newQuantityController.text = parsedQuantity
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
