import 'package:celta_inventario/components/Global_widgets/consulting_widget.dart';
import 'package:celta_inventario/components/Global_widgets/try_again.dart';
import 'package:celta_inventario/components/Transfer_request/transfer_origin_enterprise_items.dart';
import 'package:celta_inventario/providers/transfer_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    return WillPopScope(
      onWillPop: () async {
        transferRequestProvider.clearOriginEnterprise();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'EMPRESA DE ORIGEM  ',
          ),
          leading: IconButton(
            onPressed: () {
              // transferRequestProvider.clearTransferRequestModels();
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
            if (transferRequestProvider.isLoadingOriginEnterprise)
              Expanded(
                child: ConsultingWidget.consultingWidget(
                  title: 'Consultando empresas de origem',
                ),
              ),
            if (!transferRequestProvider.isLoadingOriginEnterprise &&
                transferRequestProvider.errorMessageOriginEnterprise == "")
              const TransferOriginEnterpriseItems(),
            if (transferRequestProvider.errorMessageOriginEnterprise != '' &&
                !transferRequestProvider.isLoadingOriginEnterprise)
              Expanded(
                child: TryAgainWidget.tryAgain(
                    errorMessage:
                        transferRequestProvider.errorMessageOriginEnterprise,
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
    );
  }
}