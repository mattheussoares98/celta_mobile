import 'package:celta_inventario/api/api.dart';
import 'package:celta_inventario/components/global_widgets/global_widgets.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class WebHomePage extends StatefulWidget {
  const WebHomePage({super.key});

  @override
  State<WebHomePage> createState() => _WebHomePageState();
}

class _WebHomePageState extends State<WebHomePage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Center(
            child: TextButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                try {
                  final clients = await FirebaseHelper.getAllClients();
                  print(clients);
                } catch (e) {
                  ShowSnackbarMessage.showMessage(
                    message: DefaultErrorMessageToFindServer.ERROR_MESSAGE,
                    context: context,
                  );
                }
                setState(() {
                  _isLoading = false;
                });
              },
              child: const Text(
                "Consultar clientes",
              ),
            ),
          ),
        ),
        loadingWidget(
          message: "Consultando clientes...",
          isLoading: _isLoading,
        ),
      ],
    );
  }
}
