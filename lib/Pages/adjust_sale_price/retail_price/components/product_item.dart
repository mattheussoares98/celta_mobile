import '../../../../models/enterprise/enterprise.dart';
import '../../../../models/soap/soap.dart';
import '../../../../pages/adjust_sale_price/adjust_sale_price.dart';

import 'package:flutter/material.dart';

class ProductItem extends StatefulWidget {
  final Function() updateSelectedIndex;
  final GetProductJsonModel product;
  final int index;
  final int? selectedIndex;
  const ProductItem({
    required this.updateSelectedIndex,
    required this.product,
    required this.index,
    required this.selectedIndex,
    super.key,
  });

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  String initialDate = "Data atual";
  String finishDate = "Sem término";

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
              selectedIndex: widget.selectedIndex,
              updateSelectedIndex: widget.updateSelectedIndex,
            ),
            if (widget.selectedIndex == widget.index)
              Column(
                children: [
                  PriceTypeRadios(enterpriseModel: enterprise),
                  const SaleTypeRadios(),
                  const ReplicationParameters(),
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
