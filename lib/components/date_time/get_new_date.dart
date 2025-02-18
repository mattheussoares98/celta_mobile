import 'package:flutter/material.dart';

import '../components.dart';

class GetNewDate {
  GetNewDate._();

  static Future<DateTime?> get({
    required BuildContext context,
    bool? canInsertDateBeforeNow = false,
    bool insertHoursAndMinutes = true,
  }) async {
    DateTime now = DateTime.now();

    DateTime? validityDate = await showDatePicker(
      context: context,
      firstDate: now,
      initialDate: now,
      lastDate: now.add(const Duration(days: 1825)),
      locale: const Locale('pt', 'BR'),
    );

    if (!insertHoursAndMinutes) {
      return validityDate;
    }

    if (validityDate != null) {
      TimeOfDay? newTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (newTime == null) {
        ShowSnackbarMessage.show(
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

        if (selectedDateTime.isBefore(now) && canInsertDateBeforeNow == false) {
          ShowSnackbarMessage.show(
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
}
