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
        generateRadios(adjustSalePriceProvider)
      ],
    );
  }

  Widget generateRadios(AdjustSalePriceProvider adjustSalePriceProvider) {
    List<Widget> radios = [];

    for (var i = 0; i < priceTypes.length; i++) {
      radios.add(
        Expanded(
          child: InkWell(
            onTap: () {
              setState(() {
                groupValue = i;
              });
            },
            child: Row(
              children: [
                Expanded(
                  child: Radio(
                    value: i,
                    visualDensity: VisualDensity.compact,
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() {
                        groupValue = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    priceTypes[i],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ...radios,
      ],
    );
  }
}
