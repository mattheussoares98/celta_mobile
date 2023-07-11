import 'package:celta_inventario/components/Global_widgets/consulting_widget.dart';
import 'package:celta_inventario/components/Global_widgets/try_again.dart';
import 'package:celta_inventario/components/Transfer_request/transfer_request_items.dart';
import 'package:celta_inventario/providers/transfer_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    return WillPopScope(
      onWillPop: () async {
        // adjustStockProvider
        //     .clearProductsJustificationsStockTypesAndJsonAdjustStock();
        return true;
      },
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
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (transferRequestProvider.isLoadingRequestModel)
              Expanded(
                child: ConsultingWidget.consultingWidget(
                  title: 'Consultando modelos de pedido',
                ),
              ),
            if (!transferRequestProvider.isLoadingRequestModel &&
                transferRequestProvider.errorMessageRequestModel == "")
              const TransferRequestItems(),
            if (transferRequestProvider.errorMessageRequestModel != '' &&
                !transferRequestProvider.isLoadingRequestModel)
              Expanded(
                child: TryAgainWidget.tryAgain(
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
    );
  }
}
