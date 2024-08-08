import 'package:flutter/material.dart';

import '../../models/soap/soap.dart';
import '../../utils/utils.dart';
import '../components.dart';

class Costs extends StatelessWidget {
  final GetProductJsonModel product;
  const Costs({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Text(
            "CUSTOS",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TitleAndSubtitle.titleAndSubtitle(
          subtitle: ConvertString.convertToBRL(
            product.fiscalCost,
          ),
          title: "Fiscal",
        ),
        TitleAndSubtitle.titleAndSubtitle(
          subtitle: ConvertString.convertToBRL(
            product.fiscalLiquidCost,
          ),
          title: "Fiscal líquido",
        ),
        TitleAndSubtitle.titleAndSubtitle(
          subtitle: ConvertString.convertToBRL(
            product.liquidCost,
          ),
          title: "Líquido",
        ),
        TitleAndSubtitle.titleAndSubtitle(
          subtitle: ConvertString.convertToBRL(
            product.liquidCostMidle,
          ),
          title: "Líquido médio",
        ),
        TitleAndSubtitle.titleAndSubtitle(
          subtitle: ConvertString.convertToBRL(
            product.operationalCost,
          ),
          title: "Operacional",
        ),
        TitleAndSubtitle.titleAndSubtitle(
          subtitle: ConvertString.convertToBRL(
            product.realCost,
          ),
          title: "Real",
        ),
        TitleAndSubtitle.titleAndSubtitle(
          subtitle: ConvertString.convertToBRL(
            product.realLiquidCost,
          ),
          title: "Real líquido",
        ),
        TitleAndSubtitle.titleAndSubtitle(
          subtitle: ConvertString.convertToBRL(
            product.replacementCost,
          ),
          title: "Reposição",
        ),
        TitleAndSubtitle.titleAndSubtitle(
          subtitle: ConvertString.convertToBRL(
            product.replacementCostMidle,
          ),
          title: "Reposição médio",
        ),
      ],
    );
  }
}
