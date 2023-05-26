import 'package:celta_inventario/components/Global_widgets/personalized_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/enterprise_json_provider.dart';

///quando seleciona o pedido de vendas utiliza esses itens porque na consulta de
///empresas retorna informações diferentes das que são retornadas nas outras
///consultas de empresas

class EnterpriseJsonItems extends StatefulWidget {
  final String nextPageRoute;
  const EnterpriseJsonItems({
    required this.nextPageRoute,
    Key? key,
  }) : super(key: key);

  @override
  State<EnterpriseJsonItems> createState() => _EnterpriseJsonItemsState();
}

class _EnterpriseJsonItemsState extends State<EnterpriseJsonItems> {
  @override
  Widget build(BuildContext context) {
    EnterpriseJsonProvider enterpriseJsonProvider =
        Provider.of(context, listen: true);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Selecione a empresa',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: enterpriseJsonProvider.enterpriseCount,
            itemBuilder: (ctx, index) {
              return PersonalizedCard.personalizedCard(
                context: context,
                child: ListTile(
                  title: Text(
                    enterpriseJsonProvider.enterprises[index].Name,
                    style: const TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  leading: Text(
                    enterpriseJsonProvider.enterprises[index].PersonalizedCode
                        .toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  subtitle: Text(
                    "Cnpj: " +
                        enterpriseJsonProvider.enterprises[index].CnpjNumber
                            .toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      widget.nextPageRoute,
                      arguments: {
                        "Code": enterpriseJsonProvider.enterprises[index].Code,
                        "SaleRequestTypeCode": enterpriseJsonProvider
                            .enterprises[index].SaleRequestTypeCode,
                      },
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
