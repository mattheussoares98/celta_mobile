import 'package:celta_inventario/providers/inventory_product_provider.dart';
import 'package:celta_inventario/utils/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InventoryConfirmQuantityButton extends StatefulWidget {
  final int countingCode;
  final TextEditingController consultedProductController;
  final bool isSubtract;
  final GlobalKey<FormState> formKey;
  final bool isIndividual;
  final FocusNode consultedProductFocusNode;
  final InventoryProductProvider inventoryProductProvider;

  InventoryConfirmQuantityButton({
    required this.inventoryProductProvider,
    required this.consultedProductController,
    required this.countingCode,
    required this.isSubtract,
    required this.formKey,
    required this.isIndividual,
    required this.consultedProductFocusNode,
    Key? key,
  }) : super(key: key);

  @override
  State<InventoryConfirmQuantityButton> createState() =>
      _InventoryConfirmQuantityButtonState();
}

class _InventoryConfirmQuantityButtonState
    extends State<InventoryConfirmQuantityButton> {
  alterFocusToConsultedProduct() {
    Future.delayed(const Duration(milliseconds: 400), () {
      //se não colocar em um future, da erro pra alterar o foco porque tenta trocar enquanto o campo está desabilitado
      FocusScope.of(context).requestFocus(widget.consultedProductFocusNode);
    });
  }

  addQuantity() async {
    bool isValid = widget.formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    double quantity = double.tryParse(
        widget.consultedProductController.text.replaceAll(RegExp(r','), '.'))!;

    if (quantity >= 10000) {
      //se a quantidade digitada for maior que 10.000, vai abrir um alertDialog pra confirmar a quantidade
      ShowAlertDialog().showAlertDialog(
        context: context,
        title: 'Deseja confirmar a quantidade?',
        subtitle: widget.isSubtract
            ? 'Quantidade digitada: -${quantity.toStringAsFixed(3)}'
            : 'Quantidade digitada: ${quantity.toStringAsFixed(3)}',
        function: () async => await widget.inventoryProductProvider.addQuantity(
          isIndividual: widget.isIndividual,
          context: context,
          codigoInternoInvCont: widget.countingCode,
          quantity: widget.consultedProductController,
          isSubtract: widget.isSubtract,
          alterFocusToConsultedProduct: alterFocusToConsultedProduct,
        ),
      );
    } else {
      //se a quantidade digitada for menor do que 10.000, vai adicionar direto a quantidade, sem o alertDialog pra confirmar
      await widget.inventoryProductProvider.addQuantity(
        isIndividual: widget.isIndividual,
        context: context,
        codigoInternoInvCont: widget.countingCode,
        quantity: widget.consultedProductController,
        isSubtract: widget.isSubtract,
        alterFocusToConsultedProduct: alterFocusToConsultedProduct,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    InventoryProductProvider inventoryProductProvider =
        Provider.of(context, listen: true);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 70),
        maximumSize: const Size(double.infinity, 70),
      ),
      onPressed: inventoryProductProvider.isLoadingQuantity
          ? null
          : () async => await addQuantity(),
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
                    height: 40,
                    width: 40,
                    child: const CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            )
          : FittedBox(
              child: Text(
                widget.isSubtract ? 'SUBTRAIR' : 'SOMAR',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 40,
                ),
              ),
            ),
    );
  }
}
