import 'package:celta_inventario/Components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/Models/transfer_request/transfer_destiny_enterprise_model.dart';
import 'package:celta_inventario/providers/transfer_request_provider.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransferDestinyEnterpriseItems extends StatefulWidget {
  const TransferDestinyEnterpriseItems({
    Key? key,
  }) : super(key: key);

  @override
  State<TransferDestinyEnterpriseItems> createState() =>
      _TransferDestinyEnterpriseItemsState();
}

class _TransferDestinyEnterpriseItemsState
    extends State<TransferDestinyEnterpriseItems> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    TransferRequestProvider transferRequestProvider =
        Provider.of(context, listen: true);
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: transferRequestProvider.destinyEnterprisesCount,
              itemBuilder: (context, index) {
                TransferDestinyEnterpriseModel destinyEnterprise =
                    transferRequestProvider.destinyEnterprises[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      APPROUTES.TRANSFER,
                      arguments: {
                        "enterpriseOriginCode":
                            arguments["enterpriseOriginCode"],
                        "requestTypeCode": arguments["requestTypeCode"],
                        "enterpriseDestinyCode": destinyEnterprise.Code,
                      },
                    );
                  },
                  //sem esse Card, não funciona o gesture detector no campo inteiro
                  child: Card(
                    child: ListTile(
                      leading: Text(destinyEnterprise.PersonalizedCode),
                      title: Text(
                        destinyEnterprise.Name,
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
                            value: destinyEnterprise.CnpjNumber,
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
