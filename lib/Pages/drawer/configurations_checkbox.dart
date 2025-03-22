import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/configurations/configurations.dart';
import '../../providers/providers.dart';

class ConfigurationsCheckbox extends StatefulWidget {
  final List<ConfigurationType> configurations;
  const ConfigurationsCheckbox({
    required this.configurations,
    Key? key,
  }) : super(key: key);

  @override
  State<ConfigurationsCheckbox> createState() => _ConfigurationsCheckboxState();
}

class _ConfigurationsCheckboxState extends State<ConfigurationsCheckbox> {
  @override
  Widget build(BuildContext context) {
    ConfigurationsProvider configurationsProvider = Provider.of(context);

    return Column(
        children: configurationsProvider.configurations
            .map(
              (e) => (!widget.configurations.contains(e.configurationType))
                  ? Container()
                  : Card(
                      child: InkWell(
                        onTap: () {
                          e.updateValue();
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    e.title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Checkbox(
                                  value: e.value,
                                  onChanged: (_) => {
                                    e.updateValue(),
                                  },
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                              child: Text(
                                e.subtitle,
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            )
            .toList());
  }
}
