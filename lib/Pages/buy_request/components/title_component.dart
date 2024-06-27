import 'package:flutter/material.dart';

class TitleComponent extends StatelessWidget {
  final String title;
  final bool? isError;
  final String? errorTitle;
  const TitleComponent({
    required this.title,
    required this.isError,
    required this.errorTitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      errorTitle != null && isError == true ? errorTitle! : title,
      style: TextStyle(
        color: isError == true
            ? Colors.red
            : Theme.of(context).colorScheme.primary,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        fontSize: 17,
      ),
    );
  }
}
