import 'package:flutter/material.dart';

class FormFieldStyle {
  FormFieldStyle._();

  static TextStyle style({double? fontSize}) {
    return TextStyle(
      height: 1,
      fontSize: fontSize ?? 18,
      color: Colors.black,
      fontWeight: FontWeight.normal,
    );
  }
}
