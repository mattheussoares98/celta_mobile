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
        Expanded(
          child: ListView.builder(
            itemCount: enterpriseProvider.enterpriseCount,
            itemBuilder: (ctx, index) {
              return Card(
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
                    Navigator.of(context)
                        .pushNamed(widget.nextPageRoute, arguments: {
                      "CodigoInterno_Empresa": enterpriseProvider
                          .enterprises[index].codigoInternoEmpresa,
                      "CodigoInternoVendaMobile_ModeloPedido": int.tryParse(
                              enterpriseProvider.enterprises[index]
                                  .CodigoInternoVendaMobile_ModeloPedido) ??
                          0,
                    });
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
