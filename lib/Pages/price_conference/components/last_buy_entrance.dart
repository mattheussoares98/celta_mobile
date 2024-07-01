import 'package:celta_inventario/components/global_widgets/global_widgets.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/soap/products/products.dart';

Widget lastBuyEntrance({
  required BuildContext context,
  required GetProductJsonModel product,
}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Divider(),
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            "ÚLTIMA COMPRA",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (product.lastBuyEntrance == null)
          const Text("Não há compras para esse produto"),
        if (product.lastBuyEntrance != null)
          Column(
            children: [
              TitleAndSubtitle.titleAndSubtitle(
                title: "Número",
                value: product.lastBuyEntrance!.number,
              ),
              TitleAndSubtitle.titleAndSubtitle(
                title: "Data",
                value: DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(
                  product.lastBuyEntrance!.entranceDate!,
                )),
              ),
              TitleAndSubtitle.titleAndSubtitle(
                title: "Fornecedor",
                value: product.lastBuyEntrance!.supplier,
              ),
              TitleAndSubtitle.titleAndSubtitle(
                title: "Quantitade",
                value: product.lastBuyEntrance!.quantity
                    .toString()
                    .toBrazilianNumber(),
              ),
            ],
          ),
      ],
    );
