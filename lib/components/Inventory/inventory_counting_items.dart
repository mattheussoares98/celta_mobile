import 'package:celta_inventario/Components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/components/Global_widgets/personalized_card.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/inventory_counting_provider.dart';

class InventoryCountingItems extends StatelessWidget {
  final int codigoInternoEmpresa;
  const InventoryCountingItems({
    required this.codigoInternoEmpresa,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InventoryCountingProvider inventoryCountingProvider =
        Provider.of(context, listen: true);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Selecione a contagem',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: inventoryCountingProvider.countingsQuantity,
            itemBuilder: (ctx, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    APPROUTES.INVENTORY_PRODUCTS,
                    arguments: {
                      "InventoryCountingsModel":
                          inventoryCountingProvider.countings[index],
                      "codigoInternoEmpresa": codigoInternoEmpresa,
                    },
                  );
                },
                //sem esse Card, não funciona o gesture detector no campo inteiro
                child: PersonalizedCard.personalizedCard(
                  context: context,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleAndSubtitle.titleAndSubtitle(
                          title: "Número da contagem",
                          value: inventoryCountingProvider
                              .countings[index].numeroContagemInvCont
                              .toString(),
                        ),
                        TitleAndSubtitle.titleAndSubtitle(
                          title: "Observações",
                          value: inventoryCountingProvider
                              .countings[index].obsInvCont,
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
