import 'package:flutter/material.dart';

import 'configurations_checkbox.dart';

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
        primary: false,
        child: ConfigurationsCheckbox(
          showOnlyConfigurationOfSearch: false,
        ),
      ),
    );
  }
}
