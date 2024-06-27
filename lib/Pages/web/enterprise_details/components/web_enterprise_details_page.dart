import 'package:flutter/material.dart';

import '../../../../models/firebase/firebase.dart';
import 'components.dart';

class WebEnterpriseDetailsPage extends StatefulWidget {
  const WebEnterpriseDetailsPage({super.key});

  @override
  State<WebEnterpriseDetailsPage> createState() =>
      _WebEnterpriseDetailsPageState();
}

class _WebEnterpriseDetailsPageState extends State<WebEnterpriseDetailsPage> {
  @override
  Widget build(BuildContext context) {
    FirebaseClientModel client =
        ModalRoute.of(context)!.settings.arguments as FirebaseClientModel;

    return Scaffold(
      appBar: appBarPersonalized(context: context, client: client),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EditUrlCcs(client: client),
          const SizedBox(height: 20),
          if (client.usersInformations == null)
            const Text(
              "Nenhum usuário utilizou o aplicativo recentemente nessa empresa",
              textAlign: TextAlign.center,
            ),
          if (client.usersInformations?.isNotEmpty == true)
            UsersList(client: client)
        ],
      ),
    );
  }
}
