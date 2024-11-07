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
    return Container(
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        onPressed: addItemInCart,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 5),
            Expanded(
              flex: 10,
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text("Total: "),
                    Text(
                      ConvertString.convertToBRL(totalItemValue),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              flex: 8,
              child: FittedBox(
                child: Row(
                  children: [
                    Text(
                      newQuantityController.text.isEmpty
                          ? "ADICIONAR +1"
                          : "ADICIONAR",
                      style: const TextStyle(fontSize: 17),
                    ),
                    const Icon(
                      Icons.shopping_cart,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
