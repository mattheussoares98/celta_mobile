import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/providers.dart';

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
        ListView.separated(
          itemCount: webProvider
                  .enterprises[webProvider.indexOfSelectedEnterprise]
                  .subEnterprises
                  ?.length ??
              0,
          separatorBuilder: (context, index) {
            return const Divider(height: 3);
          },
          shrinkWrap: true,
          itemBuilder: (context, index) {
            // final item = webProvider
            //     .enterprises[webProvider.indexOfSelectedEnterprise]
            //     .subEnterprises?[index];

            return SizedBox();
            //TODO create new ListView.builder for subenterprises
          },
        ),
      ],
    );
  }
}
