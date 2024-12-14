import 'package:flutter/material.dart';

class InclusiveExpiredCheckbox extends StatelessWidget {
  final bool inclusiveExpired;
  final void Function() updateInclusiveExpired;
  const InclusiveExpiredCheckbox({
    required this.inclusiveExpired,
    required this.updateInclusiveExpired,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: updateInclusiveExpired,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          color: Colors.grey.withAlpha(50),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Expanded(child: Text("Considerar cotações vencidas")),
            Checkbox(
                value: inclusiveExpired,
                onChanged: (_) {
                  updateInclusiveExpired();
                })
          ],
        ),
      ),
    );
  }
}
