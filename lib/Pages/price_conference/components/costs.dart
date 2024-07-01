import 'package:flutter/material.dart';

import '../../../models/soap/products/products.dart';
import '../../../utils/utils.dart';
import '../../../components/global_widgets/global_widgets.dart';

Widget costs({
  required BuildContext context,
  required GetProductJsonModel product,
}) =>
    Column(
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
          value: ConvertString.convertToBRL(
            product.fiscalCost,
          ),
          title: "Fiscal",
        ),
        TitleAndSubtitle.titleAndSubtitle(
          value: ConvertString.convertToBRL(
            product.fiscalLiquidCost,
          ),
          title: "Fiscal líquido",
        ),
        TitleAndSubtitle.titleAndSubtitle(
          value: ConvertString.convertToBRL(
            product.liquidCost,
          ),
          title: "Líquido",
        ),
        TitleAndSubtitle.titleAndSubtitle(
          value: ConvertString.convertToBRL(
            product.liquidCostMidle,
          ),
          title: "Líquido médio",
        ),
        TitleAndSubtitle.titleAndSubtitle(
          value: ConvertString.convertToBRL(
            product.operationalCost,
          ),
          title: "Operacional",
        ),
        TitleAndSubtitle.titleAndSubtitle(
          value: ConvertString.convertToBRL(
            product.realCost,
          ),
          title: "Real",
        ),
        TitleAndSubtitle.titleAndSubtitle(
          value: ConvertString.convertToBRL(
            product.realLiquidCost,
          ),
          title: "Real líquido",
        ),
        TitleAndSubtitle.titleAndSubtitle(
          value: ConvertString.convertToBRL(
            product.replacementCost,
          ),
          title: "Reposição",
        ),
        TitleAndSubtitle.titleAndSubtitle(
          value: ConvertString.convertToBRL(
            product.replacementCostMidle,
          ),
          title: "Reposição médio",
        ),
      ],
    );
