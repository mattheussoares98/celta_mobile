import 'package:flutter/material.dart';

import '../../../../components/components.dart';

Future<DateTime?> getNewDate({
  required BuildContext context,
}) async {
  DateTime now = DateTime.now();

  DateTime? validityDate = await showDatePicker(
    context: context,
    firstDate: now,
    initialDate: now,
    lastDate: now.add(const Duration(days: 1825)),
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
      DateTime selectedDateTime = DateTime(
        validityDate.year,
        validityDate.month,
        validityDate.day,
        newTime.hour,
        newTime.minute,
      );

      if (selectedDateTime.isBefore(now)) {
        ShowSnackbarMessage.showMessage(
          message: "Horário anterior à data atual. Isso não é permitido",
          context: context,
        );
        return null;
      } else {
        return selectedDateTime;
      }
    }
  }

  return null;
}
