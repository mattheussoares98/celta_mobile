import 'package:flutter/material.dart';

class CheckBoxPersonalized extends StatelessWidget {
  final bool enabled;
  final void Function() updateEnabled;
  final String searchType;
  const CheckBoxPersonalized({
    required this.enabled,
    required this.updateEnabled,
    required this.searchType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: updateEnabled,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                searchType,
                textAlign: TextAlign.center,
              ),
            ),
            Checkbox(
              value: enabled,
              onChanged: (_) {
                updateEnabled();
              },
            ),
          ],
        ),
      ),
    );
  }
}
