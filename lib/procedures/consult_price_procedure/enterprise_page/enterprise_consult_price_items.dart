import 'package:celta_inventario/components/personalized_card.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../inventory_procedure/product_page/product_provider.dart';
import 'enterprise_consult_price_provider.dart';

class EnterpriseReceiptItems extends StatefulWidget {
  const EnterpriseReceiptItems({Key? key}) : super(key: key);

  @override
  State<EnterpriseReceiptItems> createState() => _EnterpriseReceiptItemsState();
}

class _EnterpriseReceiptItemsState extends State<EnterpriseReceiptItems> {
  @override
  Widget build(BuildContext context) {
    EnterpriseConsultPriceProvider enterpriseReceiptProvider =
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
            itemCount: enterpriseReceiptProvider.enterpriseCount,
            itemBuilder: (ctx, index) {
              return PersonalizedCard.personalizedCard(
                context: context,
                child: ListTile(
                  title: Text(
                    enterpriseReceiptProvider.enterprises[index].nomeEmpresa,
                    style: const TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  leading: Text(
                    enterpriseReceiptProvider.enterprises[index].codigoEmpresa
                        .toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  subtitle: Text(
                    "Cnpj: " +
                        enterpriseReceiptProvider.enterprises[index].cnpj
                            .toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  onTap: () {
                    productProvider.codigoInternoEmpresa =
                        enterpriseReceiptProvider
                            .enterprises[index].codigoInternoEmpresa;

                    Navigator.of(context).pushNamed(
                      APPROUTES.RECEIPT,
                      arguments: enterpriseReceiptProvider.enterprises[index],
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
