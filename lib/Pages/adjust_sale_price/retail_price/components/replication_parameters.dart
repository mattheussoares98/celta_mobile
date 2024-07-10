import 'package:flutter/material.dart';

import '../../../../models/adjust_sale_request/adjust_sale_request.dart';

class ReplicationParameters extends StatefulWidget {
  const ReplicationParameters({super.key});

  @override
  State<ReplicationParameters> createState() => _ReplicationParametersState();
}

class _ReplicationParametersState extends State<ReplicationParameters> {
  List<ReplicationModel> replicationParameters = [
    ReplicationModel(selected: false, name: "Embalagens"),
    ReplicationModel(selected: false, name: "Agrupamento operacional"),
    ReplicationModel(selected: false, name: "Classe"),
    ReplicationModel(selected: false, name: "Grade"),
  ];

  @override
  Widget build(BuildContext context) {
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
          children: replicationParameters
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
