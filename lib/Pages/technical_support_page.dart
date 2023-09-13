import 'package:celta_inventario/api/url_launcher.dart';
import 'package:flutter/material.dart';

class TechnicalSupportPage extends StatelessWidget {
  const TechnicalSupportPage({Key? key}) : super(key: key);

  Widget child({
    required String message,
    required BuildContext context,
  }) {
    return Column(
      children: [
        Text(message),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async => {
            await UrlLauncher.searchAndLaunchUrl(
              url: "tel:+55-11-3125-6767",
              context: context,
            ),
          },
          child: const Text("Ligar"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Suporte técnico"),
      ),
      body: Column(children: [
        child(
          message: "Ligar",
          context: context,
        ),
      ]),
    );
  }
}
