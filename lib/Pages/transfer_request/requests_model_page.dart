import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
import 'components/components.dart';
import '../../providers/providers.dart';

class RequestsModelPage extends StatefulWidget {
  const RequestsModelPage({Key? key}) : super(key: key);

  @override
  State<RequestsModelPage> createState() =>
      _RequestsModelPageState();
}

class _RequestsModelPageState extends State<RequestsModelPage> {
  bool isLoaded = false;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    TransferRequestProvider transferRequestProvider =
        Provider.of(context, listen: false);
    if (!isLoaded) {
      await transferRequestProvider.getRequestModels();
    }
    isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    TransferRequestProvider transferRequestProvider =
        Provider.of(context, listen: true);

    return Stack(
      children: [
        PopScope(
          onPopInvoked: (value) {
            transferRequestProvider.clearRequestModels();
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'MODELOS DE PEDIDO  ',
              ),
              actions: [
                IconButton(
                  onPressed: transferRequestProvider.isLoadingRequestModel
                      ? null
                      : () async {
                          transferRequestProvider.getRequestModels(
                              isConsultingAgain: true);
                        },
                  tooltip: "Consultar modelos de pedido",
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                transferRequestProvider.getRequestModels(
                    isConsultingAgain: true);
              },
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!transferRequestProvider.isLoadingRequestModel &&
                      transferRequestProvider.errorMessageRequestModel == "")
                    const TransferRequestItems(),
                  if (transferRequestProvider.errorMessageRequestModel != '' &&
                      !transferRequestProvider.isLoadingRequestModel)
                    Expanded(
                      child: searchAgain(
                          errorMessage:
                              transferRequestProvider.errorMessageRequestModel,
                          request: () async {
                            setState(() {});
                            await transferRequestProvider.getRequestModels();
                          }),
                    ),
                ],
              ),
            ),
          ),
        ),
        loadingWidget(
          message: 'Consultando modelos de pedido...',
          isLoading: transferRequestProvider.isLoadingRequestModel,
        ),
      ],
    );
  }
}
