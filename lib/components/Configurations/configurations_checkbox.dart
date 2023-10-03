import 'package:celta_inventario/providers/configurations_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              (e) => !e.isConfigurationOfSearch &&
                      widget.showOnlyConfigurationOfSearch
                  ? Container()
                  : Card(
                      child: CheckboxListTile(
                        value: e.value,
                        onChanged: (_) => {
                          e.changeValue(),
                        },
                        title: Text(e.title),
                        subtitle: Text(
                          e.subtitle,
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
            )
            .toList());
  }
}
