import 'package:celta_inventario/components/personalized_card.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../inventory_procedure/product_page/product_provider.dart';
import 'enterprise_provider.dart';

class EnterpriseItems extends StatefulWidget {
  const EnterpriseItems({Key? key}) : super(key: key);

  @override
  State<EnterpriseItems> createState() => _EnterpriseItemsState();
}

class _EnterpriseItemsState extends State<EnterpriseItems> {
  @override
  Widget build(BuildContext context) {
    EnterpriseProvider enterpriseProvider = Provider.of(context, listen: true);
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
            itemCount: enterpriseProvider.enterpriseCount,
            itemBuilder: (ctx, index) {
              return PersonalizedCard.personalizedCard(
                context: context,
                child: ListTile(
                  title: Text(
                    enterpriseProvider.enterprises[index].nomeEmpresa,
                    style: const TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  leading: Text(
                    enterpriseProvider.enterprises[index].codigoEmpresa
                        .toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  onTap: () {
                    productProvider.codigoInternoEmpresa = enterpriseProvider
                        .enterprises[index].codigoInternoEmpresa;

                    Navigator.of(context).pushNamed(
                      APPROUTES.INVENTORY,
                      arguments: enterpriseProvider.enterprises[index],
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
