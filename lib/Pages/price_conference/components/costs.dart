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
          padding: EdgeInsets.only(bottom: 30.0),
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
        const SizedBox(height: 8),
        TitleAndSubtitle.titleAndSubtitle(
          value: ConvertString.convertToBRL(
            product.fiscalLiquidCost,
          ),
          title: "Fiscal líquido",
        ),
        const SizedBox(height: 8),
        TitleAndSubtitle.titleAndSubtitle(
          value: ConvertString.convertToBRL(
            product.liquidCost,
          ),
          title: "Líquido",
        ),
        const SizedBox(height: 8),
        TitleAndSubtitle.titleAndSubtitle(
          value: ConvertString.convertToBRL(
            product.liquidCostMidle,
          ),
          title: "Líquido médio",
        ),
        const SizedBox(height: 8),
        TitleAndSubtitle.titleAndSubtitle(
          value: ConvertString.convertToBRL(
            product.operationalCost,
          ),
          title: "Operacional",
        ),
        const SizedBox(height: 8),
        TitleAndSubtitle.titleAndSubtitle(
          value: ConvertString.convertToBRL(
            product.realCost,
          ),
          title: "Real",
        ),
        const SizedBox(height: 8),
        TitleAndSubtitle.titleAndSubtitle(
          value: ConvertString.convertToBRL(
            product.realLiquidCost,
          ),
          title: "Real líquido",
        ),
        const SizedBox(height: 8),
        TitleAndSubtitle.titleAndSubtitle(
          value: ConvertString.convertToBRL(
            product.replacementCost,
          ),
          title: "Reposição",
        ),
        const SizedBox(height: 8),
        TitleAndSubtitle.titleAndSubtitle(
          value: ConvertString.convertToBRL(
            product.replacementCostMidle,
          ),
          title: "Reposição médio",
        ),
      ],
    );
