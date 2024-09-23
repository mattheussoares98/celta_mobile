import 'package:flutter/material.dart';

enum MoreInformationType {
  costs,
  lastBuyEntrance,
  prices,
  stockAddress,
  stocks,
}

abstract class MoreInformationWidget extends StatelessWidget {
  MoreInformationType get type;
  String get moreInformationName;
}
