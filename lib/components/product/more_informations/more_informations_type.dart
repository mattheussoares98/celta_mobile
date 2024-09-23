import 'package:flutter/material.dart';

enum MoreInformationType {
  costs,
  lastBuyEntrance,
  margins,
  prices,
  stockAddress,
  stocks,
}

abstract class MoreInformationWidget extends StatelessWidget {
  MoreInformationType get type;
  String get moreInformationName;
}
