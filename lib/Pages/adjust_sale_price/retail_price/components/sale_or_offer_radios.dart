import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/providers.dart';

class SaleOrOfferRadios extends StatefulWidget {
  const SaleOrOfferRadios({super.key});

  @override
  State<SaleOrOfferRadios> createState() => _SaleOrOfferRadiosState();
}

class _SaleOrOfferRadiosState extends State<SaleOrOfferRadios> {
  int? groupValue;

  @override
  Widget build(BuildContext context) {
    AdjustSalePriceProvider adjustSalePriceProvider = Provider.of(context);

    return Column(
      children: [
        const Divider(),
        const Text("Tipo de preço para ser alterado",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
            )),
        Row(
          children: generateRadios(adjustSalePriceProvider),
        ),
      ],
    );
  }

  List<Widget> generateRadios(AdjustSalePriceProvider adjustSalePriceProvider) {
    List<Widget> radios = [];

    for (var i = 0; i < adjustSalePriceProvider.saleOrOffer.length; i++) {
      radios.add(
        Expanded(
          child: RadioListTile(
            title: Text(adjustSalePriceProvider.saleOrOffer[i]),
            value: i,
            dense: true,
            groupValue: groupValue,
            onChanged: (value) {
              setState(() {
                groupValue = value;
              });
            },
          ),
        ),
      );
    }
    return radios;
  }
}
