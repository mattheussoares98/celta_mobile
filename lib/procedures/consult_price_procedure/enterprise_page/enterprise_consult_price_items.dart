import 'package:celta_inventario/components/personalized_card.dart';
import 'package:celta_inventario/procedures/consult_price_procedure/enterprise_page/consult_price_provider.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../inventory_procedure/product_page/product_provider.dart';

class EnterpriseConsultPriceItems extends StatefulWidget {
  const EnterpriseConsultPriceItems({Key? key}) : super(key: key);

  @override
  State<EnterpriseConsultPriceItems> createState() =>
      _EnterpriseConsultPriceItemsState();
}

class _EnterpriseConsultPriceItemsState
    extends State<EnterpriseConsultPriceItems> {
  @override
  Widget build(BuildContext context) {
    EnterpriseConsultPriceProvider enterpriseConsultPriceProvider =
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
            itemCount: enterpriseConsultPriceProvider.enterpriseCount,
            itemBuilder: (ctx, index) {
              return PersonalizedCard.personalizedCard(
                context: context,
                child: ListTile(
                  title: Text(
                    enterpriseConsultPriceProvider
                        .enterprises[index].nomeEmpresa,
                    style: const TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  leading: Text(
                    enterpriseConsultPriceProvider
                        .enterprises[index].codigoEmpresa
                        .toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  subtitle: Text(
                    "Cnpj: " +
                        enterpriseConsultPriceProvider.enterprises[index].cnpj
                            .toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  onTap: () {
                    productProvider.codigoInternoEmpresa =
                        enterpriseConsultPriceProvider
                            .enterprises[index].codigoInternoEmpresa;

                    Navigator.of(context).pushNamed(
                      APPROUTES.CONSULT_PRICE,
                      arguments: enterpriseConsultPriceProvider
                          .enterprises[index].codigoInternoEmpresa,
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
