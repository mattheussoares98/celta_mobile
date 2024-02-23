import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
import '../../components/transfer_request/transfer_request.dart';
import '../../providers/providers.dart';

class TransferRequestModelPage extends StatefulWidget {
  const TransferRequestModelPage({Key? key}) : super(key: key);

  @override
  State<TransferRequestModelPage> createState() =>
      _TransferRequestModelPageState();
}

class _TransferRequestModelPageState extends State<TransferRequestModelPage> {
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

    return PopScope(
      canPop: true,
      onPopInvoked: (_) async {},
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'MODELOS DE PEDIDO  ',
          ),
          leading: IconButton(
            onPressed: () {
              transferRequestProvider.clearRequestModels();
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
            ),
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
            transferRequestProvider.getRequestModels(isConsultingAgain: true);
          },
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (transferRequestProvider.isLoadingRequestModel)
                Expanded(
                  child: SearchingWidget(
                    title: 'Consultando modelos de pedido',
                  ),
                ),
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
    );
  }
}
