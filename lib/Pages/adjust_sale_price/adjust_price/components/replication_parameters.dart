import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Models/models.dart';
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
  bool isUpdated = false;
  void updateIsSelected(ReplicationModel replication) async {
    if (isUpdated) {
      return;
    }

    await Future.delayed(Duration.zero);

    if (replication.replicationName == ReplicationNames.Packings &&
        widget.product.alterationPriceForAllPackings == true) {
      replication.selected = true;
    }
    if (replication.replicationName == ReplicationNames.Class &&
        widget.product.markUpdateClassInAdjustSalePriceIndividual == true) {
      replication.selected = true;
    }
    if (replication.replicationName == ReplicationNames.OperationalGrouping) {
      replication.selected = true;
    }
    if (replication.replicationName == ReplicationNames.Grid &&
        widget.product.isFatherOfGrate == true) {
      replication.selected = true;
    }

    isUpdated = true;

    setState(() {});
  }

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
              updateIsSelected(e);

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
