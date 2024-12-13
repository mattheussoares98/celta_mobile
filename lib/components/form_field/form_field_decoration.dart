import 'package:flutter/material.dart';

class FormFieldDecoration {
  FormFieldDecoration._();

  static InputDecoration decoration({
    required BuildContext context,
    String? labelText,
    double? hintSize = 12,
    double? labelSize = 12,
    double? errorSize = 12,
    double? floatingLabelSize = 12,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintStyle: TextStyle(
        fontSize: hintSize,
        color: Colors.grey,
      ),
      labelStyle: TextStyle(
        fontSize: labelSize,
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
      ),
      floatingLabelStyle: TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.normal,
        fontSize: floatingLabelSize,
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
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          style: BorderStyle.solid,
          width: 1,
          color: Theme.of(context).colorScheme.error,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          style: BorderStyle.solid,
          width: 1,
          color: Theme.of(context).colorScheme.primary,
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
      suffixIcon: suffixIcon,
      hintText: hintText,
    );
  }
}
