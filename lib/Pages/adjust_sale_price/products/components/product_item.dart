import '../../../../models/adjust_sale_request/adjust_sale_request.dart';
import '../../../../models/enterprise/enterprise.dart';
import '../../../../models/soap/soap.dart';
import '../../adjust_sale_price.dart';

import 'package:flutter/material.dart';

class ProductItem extends StatefulWidget {
  final GetProductJsonModel product;
  final int index;
  const ProductItem({
    required this.product,
    required this.index,
    super.key,
  });

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
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
    final EnterpriseModel enterprise =
        ModalRoute.of(context)!.settings.arguments! as EnterpriseModel;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ProductInformations(
              product: widget.product,
              index: widget.index,
            ),
            Column(
              children: [
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
