import 'package:celta_inventario/Components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/providers/inventory_provider.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InventoryCountingItems extends StatelessWidget {
  final int codigoInternoEmpresa;
  const InventoryCountingItems({
    required this.codigoInternoEmpresa,
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
                      "codigoInternoEmpresa": codigoInternoEmpresa,
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
                          value: inventoryProvider
                              .getCountings(
                                  arguments["codigoInternoInventario"])[index]
                              .numeroContagemInvCont
                              .toString(),
                        ),
                        TitleAndSubtitle.titleAndSubtitle(
                          title: "Observações",
                          value: inventoryProvider
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
