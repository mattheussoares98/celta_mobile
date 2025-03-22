import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Models/transfer_request/transfer_request.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';
import '../../../components/components.dart';

class OriginEnterpriseItems extends StatefulWidget {
  const OriginEnterpriseItems({
    Key? key,
  }) : super(key: key);

  @override
  State<OriginEnterpriseItems> createState() => _OriginEnterpriseItemsState();
}

class _OriginEnterpriseItemsState extends State<OriginEnterpriseItems> {
  @override
  Widget build(BuildContext context) {
    TransferRequestModel selectedTransferRequestModel =
        ModalRoute.of(context)!.settings.arguments as TransferRequestModel;

    TransferRequestProvider transferRequestProvider =
        Provider.of(context, listen: true);
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: transferRequestProvider.originEnterprisesCount,
              itemBuilder: (context, index) {
                TransferRequestEnterpriseModel originEnterprise =
                    transferRequestProvider.originEnterprises[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      APPROUTES.TRANSFER_DESTINY_ENTERPRISE,
                      arguments: {
                        "selectedTransferRequestModel":
                            selectedTransferRequestModel,
                        "originEnterprise": originEnterprise,
                      },
                    );
                  },
                  //sem esse Card, não funciona o gesture detector no campo inteiro
                  child: Card(
                    child: ListTile(
                      leading: Text(originEnterprise.PersonalizedCode ?? ""),
                      title: Text(
                        originEnterprise.Name ?? "",
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
                            subtitle: originEnterprise.CnpjNumber,
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
