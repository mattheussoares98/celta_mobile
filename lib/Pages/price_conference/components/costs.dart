import 'package:flutter/material.dart';

import '../../../models/products/products.dart';
import '../../../utils/utils.dart';
import '../../../components/global_widgets/global_widgets.dart';

Widget costs({
  required BuildContext context,
  required GetProductCmxJson product,
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
            product.FiscalCost,
          ),
          title: "Fiscal",
        ),
        const SizedBox(height: 8),
        TitleAndSubtitle.titleAndSubtitle(
          value: ConvertString.convertToBRL(
            product.FiscalLiquidCost,
          ),
          title: "Fiscal líquido",
        ),
        const SizedBox(height: 8),
        TitleAndSubtitle.titleAndSubtitle(
          value: ConvertString.convertToBRL(
            product.LiquidCost,
          ),
          title: "Líquido",
        ),
        const SizedBox(height: 8),
        TitleAndSubtitle.titleAndSubtitle(
          value: ConvertString.convertToBRL(
            product.LiquidCostMidle,
          ),
          title: "Líquido médio",
        ),
        const SizedBox(height: 8),
        TitleAndSubtitle.titleAndSubtitle(
          value: ConvertString.convertToBRL(
            product.OperationalCost,
          ),
          title: "Operacional",
        ),
        const SizedBox(height: 8),
        TitleAndSubtitle.titleAndSubtitle(
          value: ConvertString.convertToBRL(
            product.RealCost,
          ),
          title: "Real",
        ),
        const SizedBox(height: 8),
        TitleAndSubtitle.titleAndSubtitle(
          value: ConvertString.convertToBRL(
            product.RealLiquidCost,
          ),
          title: "Real líquido",
        ),
        const SizedBox(height: 8),
        TitleAndSubtitle.titleAndSubtitle(
          value: ConvertString.convertToBRL(
            product.ReplacementCost,
          ),
          title: "Reposição",
        ),
        const SizedBox(height: 8),
        TitleAndSubtitle.titleAndSubtitle(
          value: ConvertString.convertToBRL(
            product.ReplacementCostMidle,
          ),
          title: "Reposição médio",
        ),
      ],
    );
