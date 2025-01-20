import 'package:flutter/material.dart';

import '../../../../models/models.dart';

class EnableOrDisableModule extends StatefulWidget {
  final List<ModuleModel> modules;
  final void Function(int index) updateEnabled;
  const EnableOrDisableModule({
    required this.modules,
    required this.updateEnabled,
    super.key,
  });

  @override
  State<EnableOrDisableModule> createState() => _EnableOrDisableModuleState();
}

class _EnableOrDisableModuleState extends State<EnableOrDisableModule> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.modules.length,
      itemBuilder: (context, index) {
        final module = widget.modules[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: SwitchListTile(
            dense: true,
            value: module.enabled == true,
            title: Text(module.name),
            tileColor: module.enabled == true
                ? Theme.of(context).colorScheme.primary.withAlpha(100)
                : Colors.red.withAlpha(100),
            onChanged: (_) {
              widget.updateEnabled(index);
            },
          ),
        );
      },
    );
  }
}
