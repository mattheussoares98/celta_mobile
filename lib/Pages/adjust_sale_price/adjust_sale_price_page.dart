import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../models/adjust_sale_request/adjust_sale_request.dart';
import '../../providers/providers.dart';
import 'adjust_sale_price.dart';

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

  @override
  Widget build(BuildContext context) {
    AdjustSalePriceProvider adjustSalePriceProvider = Provider.of(context);
    final Map arguments = ModalRoute.of(context)!.settings.arguments! as Map;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text("Alteração de preços"),
          ),
          body: Column(
            children: [
              PriceTypeRadios(enterpriseModel: arguments["enterprise"]),
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
            ],
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
