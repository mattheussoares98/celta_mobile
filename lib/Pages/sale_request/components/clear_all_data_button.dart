import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Models/models.dart';
import '../../../components/components.dart';
import '../../../providers/providers.dart';

class ClearAllDataButton extends StatelessWidget {
  const ClearAllDataButton({super.key});

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider = Provider.of(context);

    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final EnterpriseModel enterprise = arguments["enterprise"];

    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: IconButton(
        onPressed: () {
          ShowAlertDialog.show(
            context: context,
            title: "Apagar TODOS dados",
            content: const SingleChildScrollView(
              child: Text(
                "Deseja realmente limpar todos os dados do pedido?",
                textAlign: TextAlign.center,
              ),
            ),
            function: () {
              saleRequestProvider.clearCart(enterprise.Code.toString());
            },
          );
        },
        icon: FittedBox(
          child: Row(
            children: [
              Icon(
                Icons.delete,
                color: Colors.red[600],
                size: 30,
                shadows: [
                  const Shadow(
                    color: Colors.white70,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              Text(
                "LIMPAR\nPEDIDO",
                style: TextStyle(
                  color: Colors.red[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  shadows: [
                    const Shadow(
                      color: Colors.white38,
                      offset: Offset(1, 1),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
