import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
import '../../components/transfer_request/transfer_request.dart';
import '../../providers/providers.dart';

class TransferOriginEnterprisePage extends StatefulWidget {
  const TransferOriginEnterprisePage({Key? key}) : super(key: key);

  @override
  State<TransferOriginEnterprisePage> createState() =>
      _TransferOriginEnterprisePageState();
}

class _TransferOriginEnterprisePageState
    extends State<TransferOriginEnterprisePage> {
  bool isLoaded = false;
  @override
  void didChangeDependencies() async {
    int requestTypeCode = ModalRoute.of(context)!.settings.arguments as int;

    super.didChangeDependencies();
    TransferRequestProvider transferRequestProvider =
        Provider.of(context, listen: false);
    if (!isLoaded) {
      await transferRequestProvider.getOriginEnterprises(
        requestTypeCode: requestTypeCode,
      );
    }
    isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    TransferRequestProvider transferRequestProvider =
        Provider.of(context, listen: true);

    int requestTypeCode = ModalRoute.of(context)!.settings.arguments as int;

    return Stack(
      children: [
        PopScope(
          onPopInvoked: (_) {
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
                            requestTypeCode: requestTypeCode,
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
                  requestTypeCode: requestTypeCode,
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
                    const TransferOriginEnterpriseItems(),
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
                              requestTypeCode: requestTypeCode,
                            );
                          }),
                    ),
                ],
              ),
            ),
          ),
        ),
        loadingWidget(
          message: 'Consultando empresas de origem...',
          isLoading: transferRequestProvider.isLoadingOriginEnterprise,
        ),
      ],
    );
  }
}
