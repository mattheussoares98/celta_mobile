import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/firebase/firebase.dart';
import '../../../components/components.dart';
import '../../../providers/providers.dart';
import 'enterprise_details.dart';

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
        webProvider.enterprises[webProvider.indexOfSelectedEnterprise];

    return Stack(
      children: [
        PopScope(
          onPopInvokedWithResult: (didPop, result) {
            webProvider.indexOfSelectedEnterprise = -1;
          },
          child: Scaffold(
            appBar: appBarEnterprise(
              context: context,
              client: client,
              webProvider: webProvider,
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EditUrlCcs(client: client),
                    const ModulesItems(),
                    const SizedBox(height: 20),
                    // if (client.usersInformations == null)
                    //   const Text(
                    //     "Nenhum usuário utilizou o aplicativo recentemente nessa empresa",
                    //     textAlign: TextAlign.center,
                    //   ),
                    // if (client.usersInformations?.isNotEmpty == true)
                    //   UsersList(client: client)
                  ],
                ),
              ),
            ),
          ),
        ),
        loadingWidget(webProvider.isLoading),
      ],
    );
  }
}
