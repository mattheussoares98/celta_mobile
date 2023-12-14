import 'package:flutter/material.dart';

Text buyRequestTitleComponent({
  required String title,
  required BuildContext context,
  bool? isError = false,
  String? errorTitle,
}) {
  return Text(
    errorTitle != null && isError == true ? errorTitle : title,
    style: TextStyle(
      color:
          isError == true ? Colors.red : Theme.of(context).colorScheme.primary,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold,
      fontSize: 17,
    ),
  );
}
