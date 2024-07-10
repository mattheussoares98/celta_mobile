import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/soap/soap.dart';
import '../../../utils/utils.dart';
import '../global_widgets.dart';

class LastBuyEntrance extends StatelessWidget {
  final GetProductJsonModel product;
  const LastBuyEntrance({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
                subtitle: product.lastBuyEntrance!.number,
              ),
              TitleAndSubtitle.titleAndSubtitle(
                title: "Data",
                subtitle: DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(
                  product.lastBuyEntrance!.entranceDate!,
                )),
              ),
              TitleAndSubtitle.titleAndSubtitle(
                title: "Fornecedor",
                subtitle: product.lastBuyEntrance!.supplier,
              ),
              TitleAndSubtitle.titleAndSubtitle(
                title: "Quantitade",
                subtitle: product.lastBuyEntrance!.quantity
                    .toString()
                    .toBrazilianNumber(),
              ),
            ],
          ),
      ],
    );
  }
}
