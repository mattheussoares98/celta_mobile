import 'package:flutter/material.dart';

import '../../models/price_conference/price_conference.dart';
import '../../utils/utils.dart';
import '../global_widgets/global_widgets.dart';

Widget priceConferenteCosts({
  required BuildContext context,
  required PriceConferenceProductsModel product,
}) =>
    InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Fechar"),
                  )
                ],
                content: Column(
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
                ),
              );
            });
      },
      child: Row(
        children: [
          Icon(
            Icons.info,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            "Custos",
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
