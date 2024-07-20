import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../models/adjust_sale_request/adjust_sale_request.dart';
import '../../../models/enterprise/enterprise.dart';
import '../../../models/soap/products/products.dart';
import '../../../providers/providers.dart';
import '../adjust_sale_price.dart';

class AdjustSalePricePage extends StatefulWidget {
  const AdjustSalePricePage({super.key});

  @override
  State<AdjustSalePricePage> createState() => _AdjustSalePricePageState();
}

class _AdjustSalePricePageState extends State<AdjustSalePricePage> {
  String initialDate = "Data atual";
  String finishDate = "Sem término";
  List<ReplicationModel> replicationParameters = [
    ReplicationModel(name: ReplicationNames.Embalagens.description),
    ReplicationModel(name: ReplicationNames.AgrupamentoOperacional.description),
    ReplicationModel(name: ReplicationNames.Classe.description),
    ReplicationModel(name: ReplicationNames.Grade.description),
  ];

  @override
  Widget build(BuildContext context) {
    AdjustSalePriceProvider adjustSalePriceProvider = Provider.of(context);
    final Map arguments = ModalRoute.of(context)!.settings.arguments! as Map;
    final EnterpriseModel enterprise = arguments["enterprise"];
    final GetProductJsonModel product = arguments["product"];

    return PopScope(
      canPop: !adjustSalePriceProvider.isLoading,
      onPopInvoked: (_) {
        adjustSalePriceProvider.clearDataOnCloseAdjustPriceScreen();
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: FittedBox(child: Text("${product.name} (${product.plu})")),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    GetSchedulesPrices(
                        enterprise: enterprise, product: product),
                    PriceTypeRadios(enterpriseModel: enterprise),
                    const SaleTypeRadios(),
                    ReplicationParameters(
                      replicationParameters: replicationParameters,
                    ),
                    InitialAndFinishDates(
                        initialDate: initialDate,
                        finishDate: finishDate,
                        updateInitialDate: () async {
                          final newDate = await getNewDate(context: context);
                          if (newDate != null) {
                            setState(() {
                              initialDate = newDate;
                            });
                          }
                        },
                        updateFinishDate: () async {
                          final newDate = await getNewDate(context: context);
                          if (newDate != null) {
                            setState(() {
                              finishDate = newDate;
                            });
                          }
                        }),
                    PriceFieldAndConfirmAdjustButton(
                      replicationParameters: replicationParameters,
                    ),
                  ],
                ),
              ),
            ),
          ),
          loadingWidget(
            message: "Aguarde...",
            isLoading: adjustSalePriceProvider.isLoading,
          )
        ],
      ),
    );
  }
}
