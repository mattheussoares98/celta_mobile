import 'package:celta_inventario/models/enterprise/enterprise.dart';
import 'package:celta_inventario/models/soap/products/products.dart';
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
    ReplicationModel(selected: false, name: "Embalagens"),
    ReplicationModel(selected: false, name: "Agrupamento operacional"),
    ReplicationModel(selected: false, name: "Classe"),
    ReplicationModel(selected: false, name: "Grade"),
  ];
  final priceTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();

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

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(product.name.toString()),
            leading: IconButton(
              onPressed: () {
                adjustSalePriceProvider.clearDataOnCloseAdjustPriceScreen();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                GetSchedulesPrices(enterprise: enterprise, product: product),
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: PriceFormField(
                        priceTextController: priceTextController,
                        formKey: formKey,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: ConfirmAdjustPriceButton(formKey: formKey)),
                  ],
                ),
              ],
            ),
          ),
        ),
        loadingWidget(
          message: "Aguarde...",
          isLoading: adjustSalePriceProvider.isLoading,
        )
      ],
    );
  }
}
