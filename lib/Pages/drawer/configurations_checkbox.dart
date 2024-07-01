import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';

class ConfigurationsCheckbox extends StatefulWidget {
  final bool showOnlyConfigurationOfSearch;
  const ConfigurationsCheckbox({
    required this.showOnlyConfigurationOfSearch,
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
              (e) => (!e.isConfigurationOfSearch &&
                      widget.showOnlyConfigurationOfSearch)
                  ? Container()
                  : Card(
                      child: InkWell(
                        onTap: () {
                          e.changeValue();
                        },
                        child: Column(
                          children: [
                            CheckboxListTile(
                              value: e.value,
                              onChanged: (_) => {
                                e.changeValue(),
                              },
                              title: Text(
                                e.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 15),
                              ),
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
