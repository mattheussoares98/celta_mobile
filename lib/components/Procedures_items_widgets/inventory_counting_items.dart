import 'package:celta_inventario/components/personalized_card.dart';
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
                        Row(
                          children: [
                            const Text(
                              'Número da contagem: ',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                            Text(
                              inventoryCountingProvider
                                  .countings[index].numeroContagemInvCont
                                  .toString(),
                              style: const TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text(
                              'Observações: ',
                              style: const TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            if (inventoryCountingProvider
                                    .countings[index].obsInvCont.length <
                                19)
                              Expanded(
                                child: Text(
                                  inventoryCountingProvider
                                      .countings[index].obsInvCont,
                                ),
                              ),
                          ],
                        ),
                        if (inventoryCountingProvider
                                .countings[index].obsInvCont.length >
                            19)
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  inventoryCountingProvider
                                      .countings[index].obsInvCont,
                                  style: const TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
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
