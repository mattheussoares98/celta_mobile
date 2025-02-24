import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../models/models.dart';
import 'components/components.dart';
import '../../providers/providers.dart';

class OriginEnterprisePage extends StatefulWidget {
  const OriginEnterprisePage({Key? key}) : super(key: key);

  @override
  State<OriginEnterprisePage> createState() => _OriginEnterprisePageState();
}

class _OriginEnterprisePageState extends State<OriginEnterprisePage> {
  bool isLoaded = false;
  @override
  void didChangeDependencies() async {
    TransferRequestModel selectedTransferRequest =
        ModalRoute.of(context)!.settings.arguments as TransferRequestModel;

    super.didChangeDependencies();
    TransferRequestProvider transferRequestProvider =
        Provider.of(context, listen: false);
    if (!isLoaded) {
      await transferRequestProvider.getOriginEnterprises(
        requestTypeCode: selectedTransferRequest.Code,
      );
    }
    isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    TransferRequestProvider transferRequestProvider =
        Provider.of(context, listen: true);

    TransferRequestModel selectedTransferRequest =
        ModalRoute.of(context)!.settings.arguments as TransferRequestModel;

    return Stack(
      children: [
        PopScope(
          onPopInvokedWithResult: (_, __) {
            transferRequestProvider.clearOriginEnterprise();
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'EMPRESA DE ORIGEM  ',
              ),
              actions: [
                IconButton(
                  onPressed: transferRequestProvider.isLoadingOriginEnterprise
                      ? null
                      : () async {
                          await transferRequestProvider.getOriginEnterprises(
                            requestTypeCode: selectedTransferRequest.Code,
                            isConsultingAgain: true,
                          );
                        },
                  tooltip: "Consultar inventários",
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                await transferRequestProvider.getOriginEnterprises(
                  requestTypeCode: selectedTransferRequest.Code,
                  isConsultingAgain: true,
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!transferRequestProvider.isLoadingOriginEnterprise &&
                      transferRequestProvider.errorMessageOriginEnterprise ==
                          "")
                    const OriginEnterpriseItems(),
                  if (transferRequestProvider.errorMessageOriginEnterprise !=
                          '' &&
                      !transferRequestProvider.isLoadingOriginEnterprise)
                    Expanded(
                      child: searchAgain(
                          errorMessage: transferRequestProvider
                              .errorMessageOriginEnterprise,
                          request: () async {
                            setState(() {});
                            await transferRequestProvider.getOriginEnterprises(
                              requestTypeCode: selectedTransferRequest.Code,
                            );
                          }),
                    ),
                ],
              ),
            ),
          ),
        ),
        loadingWidget(transferRequestProvider.isLoadingOriginEnterprise),
      ],
    );
  }
}
