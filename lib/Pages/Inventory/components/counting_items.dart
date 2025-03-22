import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Models/enterprise/enterprise.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';
import '../../../components/components.dart';

class CountingItems extends StatelessWidget {
  final EnterpriseModel enterprise;
  const CountingItems({
    required this.enterprise,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InventoryProvider inventoryProvider = Provider.of(context, listen: true);
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: inventoryProvider
                .getCountingsQuantity(arguments["codigoInternoInventario"]),
            itemBuilder: (ctx, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    APPROUTES.INVENTORY_PRODUCTS,
                    arguments: {
                      "InventoryCountingsModel": inventoryProvider.getCountings(
                          arguments["codigoInternoInventario"])[index],
                      "enterprise": enterprise,
                    },
                  );
                },
                //sem esse Card, não funciona o gesture detector no campo inteiro
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleAndSubtitle.titleAndSubtitle(
                          title: "Número da contagem",
                          subtitle: inventoryProvider
                              .getCountings(
                                  arguments["codigoInternoInventario"])[index]
                              .numeroContagemInvCont
                              .toString(),
                        ),
                        TitleAndSubtitle.titleAndSubtitle(
                          title: "Observações",
                          subtitle: inventoryProvider
                              .getCountings(
                                  arguments["codigoInternoInventario"])[index]
                              .obsInvCont,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
