import 'package:flutter/material.dart';

import '../../../../models/adjust_sale_request/adjust_sale_request.dart';

class ReplicationParameters extends StatefulWidget {
  final List<ReplicationModel> replicationParameters;
  const ReplicationParameters({
    required this.replicationParameters,
    super.key,
  });

  @override
  State<ReplicationParameters> createState() => _ReplicationParametersState();
}

class _ReplicationParametersState extends State<ReplicationParameters> {
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
          children: widget.replicationParameters
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
                          e.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Checkbox(
                        value: e.selected,
                        onChanged: (bool? newValue) {
                          setState(() {
                            e.selected = newValue;
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
