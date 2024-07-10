import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/enterprise/enterprise.dart';
import '../../../../providers/providers.dart';

class PriceTypeRadios extends StatefulWidget {
  final EnterpriseModel enterpriseModel;
  const PriceTypeRadios({
    required this.enterpriseModel,
    super.key,
  });

  @override
  State<PriceTypeRadios> createState() => _SaleTypeRadiosState();
}

class _SaleTypeRadiosState extends State<PriceTypeRadios> {
  int? groupValue;

  List<String> priceTypes = [];
  @override
  void initState() {
    super.initState();

    if (widget.enterpriseModel.useRetailSale) {
      priceTypes.add("Varejo");
    }
    if (widget.enterpriseModel.useWholeSale) {
      priceTypes.add("Atacado");
    }
    if (widget.enterpriseModel.useEcommerceSale) {
      priceTypes.add("Ecommerce");
    }

    Future.delayed(Duration.zero, () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    AdjustSalePriceProvider adjustSalePriceProvider = Provider.of(context);

    return Column(
      children: [
        const Divider(),
        const Text(
          "Tipo de preço",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
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

    for (var i = 0; i < priceTypes.length; i++) {
      radios.add(
        Expanded(
          child: RadioListTile(
            title: Text(priceTypes[i]),
            visualDensity: VisualDensity.compact,
            contentPadding: const EdgeInsets.all(0),
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
