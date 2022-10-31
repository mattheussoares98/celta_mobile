import 'package:celta_inventario/utils/show_alert_dialog.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/inventory_product_provider.dart';

class InventoryAnullQuantityButton extends StatefulWidget {
  final int countingCode;
  final int productPackingCode;
  const InventoryAnullQuantityButton({
    Key? key,
    required this.countingCode,
    required this.productPackingCode,
  }) : super(key: key);

  @override
  State<InventoryAnullQuantityButton> createState() =>
      _InventoryAnullQuantityButtonState();
}

class _InventoryAnullQuantityButtonState
    extends State<InventoryAnullQuantityButton> {
  @override
  Widget build(BuildContext context) {
    InventoryProductProvider inventoryProductProvider =
        Provider.of(context, listen: true);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.red,
      ),
      onPressed: inventoryProductProvider.isLoadingQuantity
          ? null
          : () async {
              ShowAlertDialog().showAlertDialog(
                context: context,
                title: 'Deseja anular a quantidade?',
                function: () async {
                  await inventoryProductProvider.anullQuantity(
                    countingCode: widget.countingCode,
                    productPackingCode: widget.productPackingCode,
                    userIdentity: UserIdentity.identity,
                    context: context,
                    inventoryProductProvider: inventoryProductProvider,
                  );
                  // if (inventoryProductProvider.isConfirmedAnullQuantity) {
                  //   //caso o errorMessage esteja diferente de '' é porque deu erro
                  //   //pra confirmar a quantidade e por isso vai apresentar a mensagem de erro
                  //   setState(() {
                  //     inventoryProductProvider
                  //         .products[0].quantidadeInvContProEmb = -1;
                  //   });
                  // }
                },
              );
            },
      child: inventoryProductProvider.isLoadingQuantity
          ? FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'CONFIRMANDO...',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Container(
                    height: 25,
                    width: 25,
                    child: const CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            )
          : FittedBox(
              child: Text(
                'ANULAR',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 1000,
                ),
              ),
            ),
    );
  }
}
