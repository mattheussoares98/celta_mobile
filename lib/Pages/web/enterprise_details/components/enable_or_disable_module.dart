import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/providers.dart';

class EnableOrDisableModule extends StatelessWidget {
  final bool enabled;
  final String moduleName;
  final int index;
  const EnableOrDisableModule({
    required this.enabled,
    required this.moduleName,
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    WebProvider webProvider = Provider.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    enabled ? Icons.verified_rounded : Icons.close,
                    color: enabled ? Colors.green : Colors.red,
                    size: 35,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    moduleName,
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  await webProvider.enableOrDisableModule(index);
                },
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
