import 'package:flutter/material.dart';

import '../../../utils/utils.dart';

class InsertNotFoundProductButton extends StatelessWidget {
  final int docCode;
  const InsertNotFoundProductButton({
    required this.docCode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                APPROUTES.RECEIPT_INSERT_PRODUCT_WITHOUT_CADASTER,
                arguments: {
                  "docCode": docCode,
                  "isInserting": true,
                },
              );
            },
            child: const Text("Inserir produto não encontrado"),
          ),
        ],
      ),
    );
  }
}
