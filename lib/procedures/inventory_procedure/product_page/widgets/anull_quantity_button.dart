import 'package:celta_inventario/procedures/inventory_procedure/provider/quantity_provider.dart';
import 'package:celta_inventario/utils/show_alert_dialog.dart';
import 'package:celta_inventario/utils/show_error_message.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../product_provider.dart';

class AnullQuantityButton extends StatefulWidget {
  final int countingCode;
  final int productPackingCode;
  const AnullQuantityButton({
    Key? key,
    required this.countingCode,
    required this.productPackingCode,
  }) : super(key: key);

  @override
  State<AnullQuantityButton> createState() => _AnullQuantityButtonState();
}

class _AnullQuantityButtonState extends State<AnullQuantityButton> {
  anullQuantity() async {
    QuantityProvider quantityProvider = Provider.of(context, listen: false);
    ProductProvider productProvider = Provider.of(context, listen: false);
    await quantityProvider.anullQuantity(
      countingCode: widget.countingCode,
      productPackingCode: widget.productPackingCode,
      userIdentity: UserIdentity.identity,
    );
    setState(() {
      if (quantityProvider.isConfirmedAnullQuantity) {
        productProvider.products[0].quantidadeInvContProEmb = -1;
      }
      //caso o errorMessage esteja diferente de '' é porque deu erro
      //pra confirmar a quantidade e por isso vai apresentar a mensagem de erro
      if (quantityProvider.errorMessage != '') {
        ShowErrorMessage().showErrorMessage(
          error: quantityProvider.errorMessage,
          context: context,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    QuantityProvider quantityProvider = Provider.of(context, listen: true);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.red,
      ),
      onPressed: quantityProvider.isLoadingQuantity
          ? null
          : () async {
              print('teste');
              ShowAlertDialog().showAlertDialog(
                context: context,
                title: 'Deseja anular a quantidade?',
                function: () async {
                  print('teste');
                  await anullQuantity();
                },
              );
            },
      child: quantityProvider.isLoadingQuantity
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
