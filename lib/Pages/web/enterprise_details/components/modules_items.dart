import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/providers.dart';
import '../../web.dart';

class ModulesItems extends StatelessWidget {
  const ModulesItems({super.key});

  @override
  Widget build(BuildContext context) {
    WebProvider webProvider = Provider.of(context);

    return Column(
      children: [
        const Divider(),
        const Text(
          "Módulos habilitados e desabilitados",
          style: const TextStyle(
            fontFamily: "BebasNeue",
            fontSize: 30,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: webProvider.selectedModules.length,
          itemBuilder: (context, index) {
            final item = webProvider.selectedModules[index];

            return EnableOrDisableModule(
              enabled: item.enabled,
              moduleName: item.name,
              index: index,
            );
          },
        ),
      ],
    );
  }
}
