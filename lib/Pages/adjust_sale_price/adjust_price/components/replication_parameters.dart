import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/adjust_sale_price/adjust_sale_price.dart';
import '../../../../models/soap/soap.dart';
import '../../../../providers/providers.dart';

class ReplicationParameters extends StatefulWidget {
  final GetProductJsonModel product;
  const ReplicationParameters({
    required this.product,
    super.key,
  });

  @override
  State<ReplicationParameters> createState() => _ReplicationParametersState();
}

class _ReplicationParametersState extends State<ReplicationParameters> {
  @override
  Widget build(BuildContext context) {
    AdjustSalePriceProvider adjustSalePriceProvider = Provider.of(context);

    return Column(
      children: [
        const Divider(),
        const Text(
          "Parâmetros de replicação",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        Column(
          children: adjustSalePriceProvider.replicationParameters.map(
            (e) {
              if (e.replicationName == ReplicationNames.Embalagens &&
                  widget.product.alterationPriceForAllPackings == true) {
                e.selected = true;
              }
              if (e.replicationName == ReplicationNames.Classe &&
                  widget.product.markUpdateClassInAdjustSalePriceIndividual ==
                      true) {
                e.selected = true;
              }
              if (e.replicationName ==
                  ReplicationNames.AgrupamentoOperacional) {
                e.selected = true;
              }
              return InkWell(
                onTap: () {
                  setState(() {
                    if (e.selected == true) {
                      e.selected = false;
                    } else {
                      e.selected = true;
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        e.replicationName.description,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Checkbox(
                      value: e.selected,
                      onChanged: (bool? newValue) {
                        setState(() {
                          e.selected = newValue ?? false;
                        });
                      },
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
