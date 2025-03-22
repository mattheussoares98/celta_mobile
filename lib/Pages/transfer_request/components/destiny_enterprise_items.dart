import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/transfer_request/transfer_request.dart';
import '../../../providers/providers.dart';
import '../../../components/components.dart';
import '../../../utils/app_routes.dart';

class DestinyEnterpriseItems extends StatefulWidget {
  const DestinyEnterpriseItems({
    Key? key,
  }) : super(key: key);

  @override
  State<DestinyEnterpriseItems> createState() => _DestinyEnterpriseItemsState();
}

class _DestinyEnterpriseItemsState extends State<DestinyEnterpriseItems> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    TransferRequestProvider transferRequestProvider =
        Provider.of(context, listen: true);
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    TransferRequestEnterpriseModel originEnterprise =
        arguments["originEnterprise"];
    TransferRequestModel selectedTransferRequestModel =
        arguments["selectedTransferRequestModel"];

    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: transferRequestProvider.destinyEnterprisesCount,
              itemBuilder: (context, index) {
                TransferRequestEnterpriseModel destinyEnterprise =
                    transferRequestProvider.destinyEnterprises[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      APPROUTES.TRANSFER,
                      arguments: {
                        "originEnterprise": originEnterprise,
                        "selectedTransferRequestModel":
                            selectedTransferRequestModel,
                        "destinyEnterprise": destinyEnterprise,
                      },
                    );
                  },
                  //sem esse Card, não funciona o gesture detector no campo inteiro
                  child: Card(
                    child: ListTile(
                      leading: Text(destinyEnterprise.PersonalizedCode ?? ""),
                      title: Text(
                        destinyEnterprise.Name ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "CNPJ",
                            subtitle: destinyEnterprise.CnpjNumber,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
