import 'package:flutter/material.dart';

class InitialAndFinishDates extends StatelessWidget {
  final String initialDate;
  final String finishDate;
  final Function() updateInitialDate;
  final Function() updateFinishDate;
  const InitialAndFinishDates({
    required this.initialDate,
    required this.finishDate,
    required this.updateInitialDate,
    required this.updateFinishDate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(initialDate),
                  TextButton(
                    child: const Text(
                      "Alterar data de início",
                      textAlign: TextAlign.center,
                    ),
                    onPressed: updateInitialDate,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(finishDate),
                  TextButton(
                    child: const Text(
                      "Alterar data de término",
                      textAlign: TextAlign.center,
                    ),
                    onPressed: updateFinishDate,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
