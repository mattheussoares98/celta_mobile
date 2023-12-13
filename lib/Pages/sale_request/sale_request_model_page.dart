import 'package:celta_inventario/components/Sale_request/sale_request_models_items.dart';
import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/Global_widgets/searchAgain.dart';
import '../../components/Global_widgets/searching_widget.dart';

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
      if (arguments["CodigoInternoVendaMobile_ModeloPedido"] == -1) {
        //significa que não possui um modelo de pedido de vendas padrão cadastrado no BS
        _hasDefaultRequestModel = false;
      } else {
        _hasDefaultRequestModel = true;
      }

      await saleRequestProvider.getRequests(
        enterpriseCode: arguments["CodigoInterno_Empresa"],
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

    return PopScope(
      canPop: !saleRequestProvider.isLoadingRequests,
      onPopInvoked: (_) async {
        saleRequestProvider.clearProducts();
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const FittedBox(
            child: Text(
              "Modelos de pedido",
            ),
          ),
          actions: [
            IconButton(
              onPressed: saleRequestProvider.isLoadingRequests
                  ? null
                  : () async {
                      await saleRequestProvider.getRequests(
                        enterpriseCode: arguments["CodigoInterno_Empresa"],
                        context: context,
                        isConsultingAgain: true,
                      );
                    },
              tooltip: "Consultar inventários",
              icon: const Icon(Icons.refresh),
            ),
          ],
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
        body: RefreshIndicator(
          onRefresh: () => saleRequestProvider.getRequests(
            enterpriseCode: arguments["CodigoInterno_Empresa"],
            context: context,
            isConsultingAgain: true,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (saleRequestProvider.isLoadingRequests)
                Expanded(
                  child: searchingWidget(
                    title: 'Consultando modelos de pedido',
                  ),
                ),
              if (!saleRequestProvider.isLoadingRequests)
                SaleRequestModelsItems(
                  hasDefaultRequestModel: _hasDefaultRequestModel,
                  enterpriseCode: arguments["CodigoInterno_Empresa"],
                  saleRequestTypeCode:
                      arguments["CodigoInternoVendaMobile_ModeloPedido"],
                ),
              if (saleRequestProvider.errorMessageRequests != "" &&
                  saleRequestProvider.productsCount == 0)
                Expanded(
                  child: searchAgain(
                    errorMessage: saleRequestProvider.errorMessageRequests,
                    request: () async {
                      setState(() {});
                      await saleRequestProvider.getRequests(
                        enterpriseCode: arguments["CodigoInterno_Empresa"],
                        context: context,
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
