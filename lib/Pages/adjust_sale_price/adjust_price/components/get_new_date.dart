import 'package:flutter/material.dart';

import '../../../../components/components.dart';

Future<DateTime?> getNewDate({
  required BuildContext context,
}) async {
  DateTime? validityDate = await showDatePicker(
    context: context,
    firstDate: DateTime.now(),
    initialDate: DateTime.now(),
    lastDate: DateTime.now().add(const Duration(days: 1825)),
    locale: const Locale('pt', 'BR'),
  );

  if (validityDate != null) {
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (newTime == null) {
      ShowSnackbarMessage.showMessage(
        message: "Data não alterada",
        context: context,
      );
    } else {
      return DateTime(
        validityDate.year,
        validityDate.month,
        validityDate.day,
        newTime.hour,
        newTime.minute,
      );
    }
  }

  return null;
}
