import 'package:flutter/material.dart';

import '../../../utils/utils.dart';

class AddInCartButton extends StatelessWidget {
  final TextEditingController newQuantityController;
  final void Function() addItemInCart;
  final double totalItemValue;
  const AddInCartButton({
    required this.newQuantityController,
    required this.addItemInCart,
    required this.totalItemValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          newQuantityController.text.toDouble() < 0.001 ? null : addItemInCart,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: newQuantityController.text.toDouble() < 0.001
              ? Colors.grey
              : Theme.of(context).colorScheme.primary,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              child: Text(
                totalItemValue < 0.01
                    ? ConvertString.convertToBRL("0")
                    : ConvertString.convertToBRL(totalItemValue),
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const FittedBox(
              child: Text(
                "ADICIONAR",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
