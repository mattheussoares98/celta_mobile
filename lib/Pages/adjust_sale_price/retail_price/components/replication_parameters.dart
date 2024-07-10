import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/providers.dart';

class ReplicationParameters extends StatefulWidget {
  const ReplicationParameters({super.key});

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
            fontWeight: FontWeight.w400,
          ),
        ),
        Column(
          children: adjustSalePriceProvider.replicationParameters
              .map((e) => CheckboxListTile(
                    title: Text(
                      e.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    dense: true,
                    value: e.selected,
                    onChanged: (bool? newValue) {
                      setState(() {
                        e.selected = newValue;
                      });
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }
}
