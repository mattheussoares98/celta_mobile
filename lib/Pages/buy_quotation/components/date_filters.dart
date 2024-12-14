import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  Widget datePickerButton({
    required BuildContext context,
    required void Function(DateTime? date) updateDate,
    required String name,
    required DateTime? date,
    required void Function() callSetState,
  }) =>
      Container(
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.withAlpha(50),
        ),
        child: TextButton.icon(
          onPressed: () async {
            final date = await GetNewDate.get(context: context);
            if (date != null) {
              updateDate(date);
              callSetState();
            }
          },
          label: Row(
            children: [
              Expanded(child: Text(name, textAlign: TextAlign.start)),
              if (date != null)
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          DateFormat('dd/MM/yyyy HH:mm').format(date),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          updateDate(null);
                          callSetState();
                        },
                        child: const Icon(
                          Icons.delete,
                          size: 30,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          icon: const Icon(Icons.timer_outlined),
        ),
      );
}
