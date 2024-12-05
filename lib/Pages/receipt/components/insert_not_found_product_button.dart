import 'package:flutter/material.dart';

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
            onPressed: () {},
            child: const Text("Inserir produto não encontrado"),
          ),
        ],
      ),
    );
  }
}
