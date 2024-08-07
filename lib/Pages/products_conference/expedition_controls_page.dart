import 'package:flutter/material.dart';

class ExpeditionControlsPage extends StatelessWidget {
  const ExpeditionControlsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Controles de expedição"),
      ),
      body: const Center(child: Text("Controles de expedição")),
    );
  }
}
