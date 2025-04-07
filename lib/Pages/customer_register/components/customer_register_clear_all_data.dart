import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../providers/providers.dart';

class CustomerRegisterClearAllData extends StatelessWidget {
  final void Function() clearAllData;
  const CustomerRegisterClearAllData({
    required this.clearAllData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CustomerRegisterProvider customerRegisterProvider = Provider.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: FloatingActionButton(
        tooltip: "Limpar todos os dados do pedido",
        onPressed: customerRegisterProvider.customer == null
            ? null
            : () {
                ShowAlertDialog.show(
                  context: context,
                  title: "Apagar TODOS dados",
                  content: const SingleChildScrollView(
                    child: Text(
                      "Deseja realmente limpar todos os dados do pedido?",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  function: clearAllData,
                );
              },
        child: const Icon(Icons.delete, color: Colors.white),
        backgroundColor:
            customerRegisterProvider.customer == null
                ? Colors.grey.withAlpha(190)
                : Colors.red.withAlpha(190),
      ),
    );
  }
}
