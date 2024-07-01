import 'package:celta_inventario/components/global_widgets/global_widgets.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/soap/products/products.dart';

Widget lastBuyEntrance({
  required BuildContext context,
  required GetProductJsonModel product,
}) =>
    product.lastBuyEntrance == null
        ? const Center(
            child: Text("Não há compras para esse produto"),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 30.0),
                child: Text(
                  "ÚLTIMA COMPRA",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
          );
