import 'package:celta_inventario/Components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/Models/transfer_request/transfer_origin_enterprise_model.dart';
import 'package:celta_inventario/providers/transfer_request_provider.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransferOriginEnterpriseItems extends StatefulWidget {
  const TransferOriginEnterpriseItems({
    Key? key,
  }) : super(key: key);

  @override
  State<TransferOriginEnterpriseItems> createState() =>
      _TransferOriginEnterpriseItemsState();
}

class _TransferOriginEnterpriseItemsState
    extends State<TransferOriginEnterpriseItems> {
  @override
  Widget build(BuildContext context) {
    int requestTypeCode = ModalRoute.of(context)!.settings.arguments as int;

    TransferRequestProvider transferRequestProvider =
        Provider.of(context, listen: true);
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: transferRequestProvider.originEnterprisesCount,
              itemBuilder: (context, index) {
                TransferOriginEnterpriseModel originEnterprise =
                    transferRequestProvider.originEnterprises[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      APPROUTES.TRANSFER_DESTINY_ENTERPRISE,
                      arguments: {
                        "requestTypeCode": requestTypeCode,
                        "enterpriseOriginCode": originEnterprise.Code,
                      },
                    );
                  },
                  //sem esse Card, não funciona o gesture detector no campo inteiro
                  child: Card(
                    child: ListTile(
                      leading: Text(originEnterprise.PersonalizedCode),
                      title: Text(
                        originEnterprise.Name,
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
                            value: originEnterprise.CnpjNumber,
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
