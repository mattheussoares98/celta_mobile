import 'package:flutter/material.dart';

class TitleAndSubtitle {
  static TextStyle _fontStyle(
          {Color? color = Colors.black, double? fontSize = 17}) =>
      TextStyle(
        fontSize: fontSize,
        color: color,
        fontFamily: 'OpenSans',
      );
  static TextStyle _fontBoldStyle(
          {Color? color = Colors.black, double? fontSize = 17}) =>
      TextStyle(
        fontFamily: 'OpenSans',
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color,
      );

  static Widget titleAndSubtitle({
    Color? titleColor,
    Color? subtitleColor,
    Widget? otherWidget,
    String? title,
    double? fontSize = 17,
    String? value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title == null ? "" : "${title}: ",
          style: _fontStyle(color: titleColor, fontSize: fontSize),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            value ?? "",
            style: _fontBoldStyle(color: subtitleColor, fontSize: fontSize),
          ),
        ),
        if (otherWidget != null) otherWidget,
      ],
    );
  }
}
