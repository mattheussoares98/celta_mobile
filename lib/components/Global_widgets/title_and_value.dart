import 'package:flutter/material.dart';

class TitleAndSubtitle {
  static Widget titleAndSubtitle({
    Color? titleColor = Colors.black,
    Color? subtitleColor = Colors.black,
    Widget? otherWidget,
    String? title,
    double? fontSize = 17,
    String? value,
  }) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RichText(
            text: TextSpan(
              // style: _fontStyle(color: titleColor, fontSize: fontSize),
              children: <TextSpan>[
                TextSpan(
                  text: title == null ? "" : "${title}: ",
                  style: TextStyle(
                    fontSize: fontSize,
                    color: titleColor,
                    fontFamily: 'OpenSans',
                  ),
                ),
                TextSpan(
                  text: value ?? "",
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (otherWidget != null) otherWidget,
      ],
    );
  }
}
