import 'package:flutter/material.dart';

class FormFieldDecoration {
  static InputDecoration decoration({
    required bool isLoading,
    required BuildContext context,
    required String labelText,
    double? hintSize = 17,
    double? labelSize = 15,
    double? errorSize = 17,
    String? hintText,
    Widget? prefixIcon,
    Widget? sufixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintStyle: TextStyle(
        fontSize: hintSize,
        color: Colors.grey,
      ),
      labelStyle: TextStyle(
        fontSize: labelSize,
        color: isLoading ? Colors.grey : Theme.of(context).primaryColor,
      ),
      floatingLabelStyle: TextStyle(
        color: isLoading ? Colors.grey : Theme.of(context).primaryColor,
      ),
      errorStyle: TextStyle(
        fontSize: errorSize,
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          style: BorderStyle.solid,
          width: 1,
          color: Colors.grey,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          style: BorderStyle.solid,
          width: 1,
          color: Colors.grey,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          style: BorderStyle.solid,
          width: 1,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      prefixIcon: prefixIcon,
      suffixIcon: sufixIcon,
      hintText: hintText,
    );
  }
}
