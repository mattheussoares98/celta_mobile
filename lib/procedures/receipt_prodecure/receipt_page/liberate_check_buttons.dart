import 'package:celta_inventario/procedures/receipt_prodecure/receipt_page/receipt_provider.dart';
import 'package:flutter/material.dart';

class LiberateCheckButtons {
  static liberateCheckButtons({
    required int grDocCode,
    required ReceiptProvider receiptProvider,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () async {
            print(grDocCode);
            await receiptProvider.liberate(grDocCode);
          },
          child: const Text("Liberar"),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text("Conferir"),
        )
      ],
    );
  }
}
