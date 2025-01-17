import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/firebase/firebase.dart';
import '../../../../providers/providers.dart';
import '../../../../utils/utils.dart';

class WebEnterpriseItems extends StatelessWidget {
  const WebEnterpriseItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    WebProvider webProvider = Provider.of(context);

    return Expanded(
      child: ListView.builder(
        itemCount: webProvider.enterprises.length,
        itemBuilder: (context, index) {
          FirebaseEnterpriseModel client = webProvider.enterprises[index];

          return Card(
            child: ListTile(
              onTap: () {
                webProvider.indexOfSelectedEnterprise = index;
                Navigator.of(context).pushNamed(
                  APPROUTES.WEB_ENTERPRISE_DETAILS,
                );
              },
              trailing: Icon(
                Icons.remove_red_eye_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(client.enterpriseName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(client.urlCCS),
                  // if (client.usersInformations != null)
                  //   Text(
                  //       "Quantidade de usuários: ${client.usersInformations!.length}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
