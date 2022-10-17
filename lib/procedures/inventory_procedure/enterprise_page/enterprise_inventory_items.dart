import 'package:celta_inventario/components/personalized_card.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../product_page/product_provider.dart';
import 'enterprise_inventory_provider.dart';

class EnterpriseInventoryItems extends StatefulWidget {
  const EnterpriseInventoryItems({Key? key}) : super(key: key);

  @override
  State<EnterpriseInventoryItems> createState() =>
      _EnterpriseInventoryItemsState();
}

class _EnterpriseInventoryItemsState extends State<EnterpriseInventoryItems> {
  @override
  Widget build(BuildContext context) {
    EnterpriseInventoryProvider enterpriseInventoryProvider =
        Provider.of(context, listen: true);
    ProductProvider productProvider = Provider.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Selecione a empresa',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: enterpriseInventoryProvider.enterpriseCount,
            itemBuilder: (ctx, index) {
              return PersonalizedCard.personalizedCard(
                context: context,
                child: ListTile(
                  title: Text(
                    enterpriseInventoryProvider.enterprises[index].nomeEmpresa,
                    style: const TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  leading: Text(
                    enterpriseInventoryProvider.enterprises[index].codigoEmpresa
                        .toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  onTap: () {
                    productProvider.codigoInternoEmpresa =
                        enterpriseInventoryProvider
                            .enterprises[index].codigoInternoEmpresa;

                    Navigator.of(context).pushNamed(
                      APPROUTES.INVENTORY,
                      arguments: enterpriseInventoryProvider.enterprises[index],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
