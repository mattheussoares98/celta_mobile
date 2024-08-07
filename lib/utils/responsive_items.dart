import 'package:flutter/material.dart';

class ResponsiveItems {
  static const headline6 = 40.0;
  static const appBarToolbarHeight = 40.0;

  static int getItensPerLine(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 850) {
      return 1;
    } else if (screenWidth < 1300) {
      return 2;
    } else {
      return 3;
    }
  }

  static int itemCount({
    required int itemsCount,
    required BuildContext context,
  }) {
    int itensPerLine = getItensPerLine(context);
    return (itemsCount / itensPerLine).ceil();
  }
}
