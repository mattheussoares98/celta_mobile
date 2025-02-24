import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../models/models.dart';
import 'components/destiny_enterprise_items.dart';
import '../../providers/providers.dart';

class DestinyEnterprisePage extends StatefulWidget {
  const DestinyEnterprisePage({Key? key}) : super(key: key);

  @override
  State<DestinyEnterprisePage> createState() => _DestinyEnterprisePageState();
}

class _DestinyEnterprisePageState extends State<DestinyEnterprisePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        TransferRequestProvider transferRequestProvider =
            Provider.of(context, listen: false);
        Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
        TransferRequestModel selectedTranferRequestModel =
            arguments["selectedTransferRequestModel"];
        TransferRequestEnterpriseModel originEnterprise =
            arguments["originEnterprise"];

        await transferRequestProvider.getDestinyEnterprises(
          enterpriseOriginCode: originEnterprise.Code,
          requestTypeCode: selectedTranferRequestModel.Code,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TransferRequestProvider transferRequestProvider = Provider.of(context);

    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    TransferRequestModel selectedTranferRequestModel =
        arguments["selectedTransferRequestModel"];
    TransferRequestEnterpriseModel originEnterprise =
        arguments["originEnterprise"];

    return Stack(
      children: [
        PopScope(
          onPopInvokedWithResult: (_, __) {
            transferRequestProvider.clearDestinyEnterprise();
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'EMPRESA DE DESTINO  ',
              ),
              actions: [
                IconButton(
                  onPressed: transferRequestProvider.isLoadingDestinyEnterprise
                      ? null
                      : () async {
                          await transferRequestProvider.getDestinyEnterprises(
                            enterpriseOriginCode: originEnterprise.Code,
                            requestTypeCode: selectedTranferRequestModel.Code,
                          );
                        },
                  tooltip: "Consultar inventários",
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                await transferRequestProvider.getDestinyEnterprises(
                  enterpriseOriginCode: originEnterprise.Code,
                  requestTypeCode: selectedTranferRequestModel.Code,
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!transferRequestProvider.isLoadingDestinyEnterprise &&
                      transferRequestProvider.errorMessageDestinyEnterprise ==
                          "")
                    const DestinyEnterpriseItems(),
                  if (transferRequestProvider.errorMessageDestinyEnterprise !=
                          '' &&
                      !transferRequestProvider.isLoadingDestinyEnterprise)
                    Expanded(
                      child: searchAgain(
                          errorMessage: transferRequestProvider
                              .errorMessageDestinyEnterprise,
                          request: () async {
                            setState(() {});
                            await transferRequestProvider.getDestinyEnterprises(
                              enterpriseOriginCode: originEnterprise.Code,
                              requestTypeCode: selectedTranferRequestModel.Code,
                            );
                          }),
                    ),
                ],
              ),
            ),
          ),
        ),
        loadingWidget(transferRequestProvider.isLoadingDestinyEnterprise)
      ],
    );
  }
}
