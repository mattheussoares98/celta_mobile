import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
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
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      GetSchedulesPrices(
                        enterprise: enterprise,
                        product: product,
                      ),
                      SaleTypeRadios(enterpriseModel: enterprise),
                      const PriceTypeRadios(),
                      ReplicationParameters(product: product),
                      InitialAndFinishDates(
                          initialDate: adjustSalePriceProvider.initialDate ==
                                  null
                              ? "Data atual"
                              : DateFormat("dd/MM/yyy HH:mm").format(
                                  DateTime(
                                    adjustSalePriceProvider.initialDate!.year,
                                    adjustSalePriceProvider.initialDate!.month,
                                    adjustSalePriceProvider.initialDate!.day,
                                    adjustSalePriceProvider.initialDate!.hour,
                                    adjustSalePriceProvider.initialDate!.minute,
                                  ),
                                ),
                          finishDate: adjustSalePriceProvider.finishDate == null
                              ? "Data atual"
                              : DateFormat("dd/MM/yyy HH:mm").format(
                                  DateTime(
                                    adjustSalePriceProvider.finishDate!.year,
                                    adjustSalePriceProvider.finishDate!.month,
                                    adjustSalePriceProvider.finishDate!.day,
                                    adjustSalePriceProvider.finishDate!.hour,
                                    adjustSalePriceProvider.finishDate!.minute,
                                  ),
                                ),
                          updateInitialDate: () async {
                            final newDate = await getNewDate(context: context);
                            if (newDate != null) {
                              adjustSalePriceProvider.initialDate = newDate;
                            }
                          },
                          updateFinishDate: () async {
                            final newDate = await getNewDate(context: context);
                            if (newDate != null) {
                              adjustSalePriceProvider.finishDate = newDate;
                            }
                          }),
                      PriceFieldAndConfirmAdjustButton(
                        replicationParameters:
                            adjustSalePriceProvider.replicationParameters,
                      ),
                    ],
                  ),
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
