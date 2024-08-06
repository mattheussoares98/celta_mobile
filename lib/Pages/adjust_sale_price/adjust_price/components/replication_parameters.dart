import 'package:flutter/material.dart';

import '../../../../models/adjust_sale_price/adjust_sale_price.dart';
import '../../../../models/enterprise/enterprise.dart';
import '../../../../models/soap/soap.dart';

class ReplicationParameters extends StatefulWidget {
  final GetProductJsonModel product;
  final EnterpriseModel enterprise;
  const ReplicationParameters({
    required this.product,
    required this.enterprise,
    super.key,
  });

  @override
  State<ReplicationParameters> createState() => _ReplicationParametersState();
}

class _ReplicationParametersState extends State<ReplicationParameters> {
  List<ReplicationModel> replicationParameters = [
    ReplicationModel(replicationName: ReplicationNames.AgrupamentoOperacional)
  ];

  @override
  Widget build(BuildContext context) {
    if (widget.product.isFatherOfGrate == true) {
      replicationParameters
          .add(ReplicationModel(replicationName: ReplicationNames.Grade));
    }
    if (widget.product.inClass == true) {
      replicationParameters.add(
        ReplicationModel(
          replicationName: ReplicationNames.Classe,
          selected:
              widget.product.markUpdateClassInAdjustSalePriceIndividual == true,
        ),
      );
    }
    if (widget.product.alterationPriceForAllPackings == true) {
      replicationParameters
          .add(ReplicationModel(replicationName: ReplicationNames.Embalagens));
    }

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
          children: replicationParameters
              .map(
                (e) => InkWell(
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
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
