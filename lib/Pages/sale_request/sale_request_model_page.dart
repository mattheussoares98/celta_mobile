import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
import '../../components/sale_request/sale_request.dart';
import '../../providers/providers.dart';

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

    return Stack(
      children: [
        PopScope(
          onPopInvoked: (_){
            saleRequestProvider.clearRequests();
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
        ),
        loadingWidget(
          message: 'Consultando modelos de pedido',
          isLoading: saleRequestProvider.isLoadingRequests,
        ),
      ],
    );
  }
}
