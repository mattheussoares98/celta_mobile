import 'package:celta_inventario/models/enterprise/enterprise.dart';
import 'package:celta_inventario/models/soap/products/products.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../models/adjust_sale_request/adjust_sale_request.dart';
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

  final priceTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool getUpdateReplicationParameter(ReplicationNames replicationName) {
    return replicationParameters
            .firstWhere((e) => e.name == replicationName.description)
            .selected ==
        true;
  }

  Future<void> confirmAdjust(
    AdjustSalePriceProvider adjustSalePriceProvider,
  ) async {
    final Map arguments = ModalRoute.of(context)!.settings.arguments! as Map;
    final EnterpriseModel enterprise = arguments["enterprise"];
    final GetProductJsonModel product = arguments["product"];

    bool? isValid = formKey.currentState?.validate();

    if (isValid == true) {
      ShowAlertDialog.showAlertDialog(
          context: context,
          title: "Confirmar ajuste?",
          function: () async {
            await adjustSalePriceProvider.confirmAdjust(
              productPackingCode: product.productPackingCode!,
              productCode: product.productCode!,
              enterpriseCode: enterprise.codigoInternoEmpresa,
              price: priceTextController.text.toDouble(),
              updatePackings:
                  getUpdateReplicationParameter(ReplicationNames.Embalagens),
              updateEnterpriseGroup: getUpdateReplicationParameter(
                  ReplicationNames.AgrupamentoOperacional),
              updatePriceClass:
                  getUpdateReplicationParameter(ReplicationNames.Classe),
              updateGrate:
                  getUpdateReplicationParameter(ReplicationNames.Grade),
              effectuationDateOffer: DateTime.now(),
              effectuationDatePrice: DateTime.now(),
              endDateOffer: DateTime.now(),
              saleTypeInt: 1,
            );
          });
    }
  }

  @override
  void dispose() {
    super.dispose();

    priceTextController.dispose();
  }

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
              title: Text(product.name.toString()),
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
                    Column(
                      children: [
                        const Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: PriceFormField(
                                priceTextController: priceTextController,
                                formKey: formKey,
                                confirmAdjust: () async {
                                  await confirmAdjust(adjustSalePriceProvider);
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ConfirmAdjustPriceButton(
                                formKey: formKey,
                                confirmAdjust: () async {
                                  await confirmAdjust(adjustSalePriceProvider);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
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
