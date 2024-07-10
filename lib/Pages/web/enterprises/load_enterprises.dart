import 'package:flutter/material.dart';

import '../../../components/global_widgets/global_widgets.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';

class LoadEnterprises extends StatelessWidget {
  final WebProvider webProvider;
  const LoadEnterprises({
    super.key,
    required this.webProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: TextButton(
          onPressed: () async {
            await webProvider.getAllClients();

            if (webProvider.errorMessageClients != "") {
              ShowSnackbarMessage.showMessage(
                message: DefaultErrorMessageToFindServer.ERROR_MESSAGE,
                context: context,
              );
            }
          },
          child: const Text(
            "Consultar empresas",
          ),
        ),
      ),
    );
  }
}
