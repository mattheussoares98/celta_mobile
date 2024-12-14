import 'package:flutter/material.dart';

import '../../../components/components.dart';

class DateFilters extends StatelessWidget {
  final DateTime? initialDateOfCreation;
  final DateTime? finalDateOfCreation;
  final DateTime? initialDateOfLimit;
  final DateTime? finalDateOfLimit;
  final void Function(DateTime? date) updateInitialDateOfCreation;
  final void Function(DateTime? date) updateFinalDateOfCreation;
  final void Function(DateTime? date) updateInitialDateOfLimit;
  final void Function(DateTime? date) updateFinalDateOfLimit;
  final void Function() callSetState;
  const DateFilters({
    required this.initialDateOfCreation,
    required this.finalDateOfCreation,
    required this.initialDateOfLimit,
    required this.finalDateOfLimit,
    required this.updateInitialDateOfCreation,
    required this.updateFinalDateOfCreation,
    required this.updateInitialDateOfLimit,
    required this.updateFinalDateOfLimit,
    required this.callSetState,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        datePickerButton(
          callSetState: callSetState,
          context: context,
          updateDate: updateInitialDateOfCreation,
          name: "Data inicial de criação",
          date: initialDateOfCreation,
        ),
        datePickerButton(
          callSetState: callSetState,
          context: context,
          updateDate: updateFinalDateOfCreation,
          name: "Data final de criação",
          date: finalDateOfCreation,
        ),
        datePickerButton(
          callSetState: callSetState,
          context: context,
          updateDate: updateInitialDateOfLimit,
          name: "Data inicial de término",
          date: initialDateOfLimit,
        ),
        datePickerButton(
          callSetState: callSetState,
          context: context,
          updateDate: updateFinalDateOfLimit,
          name: "Data final de término",
          date: finalDateOfLimit,
        ),
      ],
    );
  }

  TextButton datePickerButton({
    required BuildContext context,
    required void Function(DateTime? date) updateDate,
    required String name,
    required DateTime? date,
    required void Function() callSetState,
  }) =>
      TextButton.icon(
        onPressed: () async {
          final date = await GetNewDate.get(context: context);
          updateDate(date);
          callSetState();
        },
        label: Row(
          children: [
            Text(name, textAlign: TextAlign.start),
            if (date != null)
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  children: [
                    Text(
                      date.toIso8601String(),
                      style: const TextStyle(color: Colors.black),
                    ),
                    IconButton(
                      onPressed: () {
                        updateDate(null);
                        callSetState();
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        icon: const Icon(Icons.timer_outlined),
      );
}
