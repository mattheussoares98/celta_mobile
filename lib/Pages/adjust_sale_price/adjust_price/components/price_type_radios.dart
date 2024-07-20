import 'package:celta_inventario/models/adjust_sale_price/price_type_model.dart';
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

  @override
  void initState() {
    super.initState();

    AdjustSalePriceProvider adjustSalePriceProvider =
        Provider.of(context, listen: false);

    adjustSalePriceProvider.addUsedPriceTypes(widget.enterpriseModel);

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
            fontWeight: FontWeight.bold,
          ),
        ),
        generateRadios(adjustSalePriceProvider)
      ],
    );
  }

  Widget generateRadios(AdjustSalePriceProvider adjustSalePriceProvider) {
    List<Widget> radios = [];

    for (var i = 0; i < adjustSalePriceProvider.priceTypes.length; i++) {
      radios.add(
        Expanded(
          child: InkWell(
            onTap: () {
              adjustSalePriceProvider.updateSelectedPriceType(i);
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
                      adjustSalePriceProvider.updateSelectedPriceType(i);
                      setState(() {
                        groupValue = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                      adjustSalePriceProvider
                          .priceTypes[i].priceTypeName.description,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                      )),
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
