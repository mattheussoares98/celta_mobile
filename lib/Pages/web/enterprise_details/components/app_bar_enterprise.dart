import 'package:flutter/material.dart';

import '../../../../../components/components.dart';
import '../../../../../models/firebase/firebase.dart';
import '../../../../providers/providers.dart';

AppBar appBarEnterprise({
  required BuildContext context,
  required FirebaseEnterpriseModel client,
  required WebProvider webProvider,
}) =>
    AppBar(
      title: Text(client.enterpriseName),
      actions: [
        TextButton.icon(
          onPressed: () {
            ShowAlertDialog.showAlertDialog(
              context: context,
              title: "Deseja realmente excluir a empresa?",
              subtitle:
                  "Todos dados da empresa serão perdidos e não será possível recuperar!",
              function: () async {
                await webProvider.deleteEnterprise(
                  context: context,
                  enterpriseId: client.id ?? "",
                );
              },
            );
          },
          label: const Text(
            "Excluir\nempresa",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          icon: const Icon(Icons.delete, color: Colors.red),
        )
      ],
    );
