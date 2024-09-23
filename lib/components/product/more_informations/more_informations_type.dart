import 'package:flutter/material.dart';

enum MoreInformationType { stocks, stockAddress, lastBuyEntrance, costs }

abstract class MoreInformationWidget extends StatelessWidget {
  MoreInformationType get type;
  String get moreInformationName;
}
