import 'package:flutter/material.dart';

class PersonalizedCard {
  static Card personalizedCard({
    required BuildContext context,
    required Widget child,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 2,
          color: Theme.of(context).colorScheme.primary,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      elevation: 6,
      child: child,
    );
  }
}
