import 'package:celta_inventario/components/Sale_request/sale_request_models_items.dart';
import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Components/Global_widgets/consulting_widget.dart';
import '../../Components/Global_widgets/try_again.dart';

class SaleRequestModelPage extends StatefulWidget {
  const SaleRequestModelPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SaleRequestModelPage> createState() => _SaleRequestModelPageState();
}

class _SaleRequestModelPageState extends State<SaleRequestModelPage> {
  bool _hasDefaultRequestModel = false;

  bool _isLoaded = false;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    SaleRequestProvider saleRequestProvider = Provider.of(
      context,
      listen: false,
    );

    if (!_isLoaded) {
      if (arguments["SaleRequestTypeCode"] == 0) {
        //significa que não possui um modelo de pedido de vendas padrão cadastrado no BS
        _hasDefaultRequestModel = false;
      } else {
        _hasDefaultRequestModel = true;
      }

      await saleRequestProvider.getRequests(
        enterpriseCode: arguments["Code"],
        context: context,
      );
      _isLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider =
        Provider.of(context, listen: true);

    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return WillPopScope(
      onWillPop: () async {
        if (saleRequestProvider.isLoadingRequests) return false;
        saleRequestProvider.clearProducts();
        return true;
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const FittedBox(
            child: Text(
              "Modelos de pedido",
            ),
          ),
          leading: IconButton(
            onPressed: saleRequestProvider.isLoadingRequests
                ? null
                : () {
                    saleRequestProvider.clearRequests();
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
          children: [
            if (saleRequestProvider.isLoadingRequests)
              Expanded(
                child: ConsultingWidget.consultingWidget(
                  title: 'Consultando modelos de pedido',
                ),
              ),
            if (!saleRequestProvider.isLoadingRequests)
              SaleRequestModelsItems(
                hasDefaultRequestModel: _hasDefaultRequestModel,
                enterpriseCode: arguments["Code"],
                saleRequestTypeCode: arguments["SaleRequestTypeCode"],
              ),
            if (saleRequestProvider.errorMessageRequests != "" &&
                saleRequestProvider.productsCount == 0)
              Expanded(
                child: TryAgainWidget.tryAgain(
                  errorMessage: saleRequestProvider.errorMessageRequests,
                  request: () async {
                    setState(() {});
                    await saleRequestProvider.getRequests(
                      enterpriseCode: arguments["Code"],
                      context: context,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
