import 'package:celta_inventario/components/Configurations/configurations_checkbox.dart';
import 'package:flutter/material.dart';

class ConfigurationsPage extends StatefulWidget {
  const ConfigurationsPage({Key? key}) : super(key: key);

  @override
  State<ConfigurationsPage> createState() => _ConfigurationsPageState();
}

class _ConfigurationsPageState extends State<ConfigurationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurações"),
      ),
      body: const SingleChildScrollView(
        child: ConfigurationsCheckbox(
          showOnlyConfigurationOfSearch: false,
        ),
      ),
    );
  }
}
