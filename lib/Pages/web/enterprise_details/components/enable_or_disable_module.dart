import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/firebase/firebase.dart';
import '../../../../models/modules/modules.dart';
import '../../../../providers/providers.dart';

class EnableOrDisableModule extends StatelessWidget {
  final bool enabled;
  final String moduleName;
  final Modules module;
  final FirebaseEnterpriseModel client;
  const EnableOrDisableModule({
    required this.enabled,
    required this.moduleName,
    required this.module,
    required this.client,
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
                onPressed: () async {
                  await webProvider.enableOrDisableModule(module, client);
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
