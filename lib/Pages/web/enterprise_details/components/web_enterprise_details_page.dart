import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/global_widgets/global_widgets.dart';
import '../../../../models/firebase/firebase.dart';
import '../../../../providers/providers.dart';
import './components.dart';

class WebEnterpriseDetailsPage extends StatefulWidget {
  const WebEnterpriseDetailsPage({super.key});

  @override
  State<WebEnterpriseDetailsPage> createState() =>
      _WebEnterpriseDetailsPageState();
}

class _WebEnterpriseDetailsPageState extends State<WebEnterpriseDetailsPage> {
  @override
  Widget build(BuildContext context) {
    WebProvider webProvider = Provider.of(context);

    FirebaseEnterpriseModel client =
        ModalRoute.of(context)!.settings.arguments as FirebaseEnterpriseModel;

    return Stack(
      children: [
        Scaffold(
          appBar: appBarEnterprise(
              context: context, client: client, webProvider: webProvider),
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
        ),
        loadingWidget(message: "Aguarde...", isLoading: webProvider.isLoading),
      ],
    );
  }
}
