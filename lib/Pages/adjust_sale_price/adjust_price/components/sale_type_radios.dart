import 'package:celta_inventario/models/adjust_sale_price/adjust_sale_price.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/providers.dart';

class SaleTypeRadios extends StatefulWidget {
  const SaleTypeRadios({super.key});

  @override
  State<SaleTypeRadios> createState() => _SaleTypeRadiosState();
}

class _SaleTypeRadiosState extends State<SaleTypeRadios> {
  int? groupValue;

  @override
  Widget build(BuildContext context) {
    AdjustSalePriceProvider adjustSalePriceProvider = Provider.of(context);

    return Column(
      children: [
        const Divider(),
        const Text(
          "Tipo de venda",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: generateRadios(adjustSalePriceProvider),
        ),
      ],
    );
  }

  List<Widget> generateRadios(AdjustSalePriceProvider adjustSalePriceProvider) {
    List<Widget> radios = [];

    for (var i = 0; i < adjustSalePriceProvider.saleTypes.length; i++) {
      radios.add(
        Expanded(
          child: InkWell(
            onTap: () {
              adjustSalePriceProvider.updateSelectedSaleType(i);
              setState(() {
                groupValue = i;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(
                  value: i,
                  groupValue: groupValue,
                  onChanged: (value) {
                    adjustSalePriceProvider.updateSelectedSaleType(i);
                    setState(() {
                      groupValue = value;
                    });
                  },
                  visualDensity: VisualDensity.compact,
                ),
                Text(
                  adjustSalePriceProvider.saleTypes[i].saleTypeName.description,
                  style: const TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return radios;
  }
}
