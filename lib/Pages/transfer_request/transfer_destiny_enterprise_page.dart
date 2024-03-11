import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
import '../../components/transfer_request/transfer_destiny_enterprise_items.dart';
import '../../providers/providers.dart';

class TransferDestinyEnterprisePage extends StatefulWidget {
  const TransferDestinyEnterprisePage({Key? key}) : super(key: key);

  @override
  State<TransferDestinyEnterprisePage> createState() =>
      _TransferDestinyEnterprisePageState();
}

class _TransferDestinyEnterprisePageState
    extends State<TransferDestinyEnterprisePage> {
  bool isLoaded = false;
  @override
  void didChangeDependencies() async {
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    super.didChangeDependencies();
    TransferRequestProvider transferRequestProvider =
        Provider.of(context, listen: true);
    if (!isLoaded) {
      await transferRequestProvider.getDestinyEnterprises(
        enterpriseOriginCode: arguments["enterpriseOriginCode"],
        requestTypeCode: arguments["requestTypeCode"],
      );
    }
    isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    TransferRequestProvider transferRequestProvider =
        Provider.of(context, listen: true);

    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return Stack(
      children: [
        PopScope(
          onPopInvoked: (_) async {
            transferRequestProvider.clearDestinyEnterprise();
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'EMPRESA DE DESTINO  ',
              ),
              leading: IconButton(
                onPressed: () {
                  transferRequestProvider.clearDestinyEnterprise();
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_outlined,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: transferRequestProvider.isLoadingDestinyEnterprise
                      ? null
                      : () async {
                          await transferRequestProvider.getDestinyEnterprises(
                            enterpriseOriginCode:
                                arguments["enterpriseOriginCode"],
                            requestTypeCode: arguments["requestTypeCode"],
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
                await transferRequestProvider.getDestinyEnterprises(
                  enterpriseOriginCode: arguments["enterpriseOriginCode"],
                  requestTypeCode: arguments["requestTypeCode"],
                  isConsultingAgain: true,
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
                    const TransferDestinyEnterpriseItems(),
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
                              enterpriseOriginCode:
                                  arguments["enterpriseOriginCode"],
                              requestTypeCode: arguments["requestTypeCode"],
                            );
                          }),
                    ),
                ],
              ),
            ),
          ),
        ),
        loadingWidget(
            message: 'Consultando empresas de destino...',
            isLoading: transferRequestProvider.isLoadingDestinyEnterprise),
      ],
    );
  }
}
