import 'package:flutter/material.dart';

import '../../../../models/modules/modules.dart';

class EnableOrDisableModule extends StatelessWidget {
  final bool enabled;
  final String moduleName;
  final Modules module;
  const EnableOrDisableModule({
    required this.enabled,
    required this.moduleName,
    required this.module,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    moduleName,
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    enabled ? Icons.verified_rounded : Icons.close,
                    color: enabled ? Colors.green : Colors.red,
                    size: 35,
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: enabled ? Colors.red : Colors.green,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    enabled ? "Desabilitar" : "Habilitar",
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
