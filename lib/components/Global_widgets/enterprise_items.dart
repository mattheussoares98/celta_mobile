import 'package:celta_inventario/components/Global_widgets/personalized_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/enterprise_provider.dart';

class EnterpriseItems extends StatefulWidget {
  final String nextPageRoute;
  const EnterpriseItems({
    required this.nextPageRoute,
    Key? key,
  }) : super(key: key);

  @override
  State<EnterpriseItems> createState() => _EnterpriseItemsState();
}

class _EnterpriseItemsState extends State<EnterpriseItems> {
  @override
  Widget build(BuildContext context) {
    EnterpriseProvider enterpriseProvider = Provider.of(context, listen: true);

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
                  subtitle: Text(
                    "Cnpj: " +
                        enterpriseProvider.enterprises[index].cnpj.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      widget.nextPageRoute,
                      arguments: enterpriseProvider
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
