import 'package:celta_inventario/Components/Global_widgets/add_subtract_or_anull_widget.dart';
import 'package:celta_inventario/Components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/components/Global_widgets/personalized_card.dart';
import 'package:celta_inventario/Components/Global_widgets/show_error_message.dart';
import 'package:celta_inventario/providers/inventory_provider.dart';
import 'package:celta_inventario/utils/convert_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Global_widgets/show_alert_dialog.dart';
import 'inventory_insert_one_quantity.dart';

class ConsultedProductWidget extends StatefulWidget {
  final int countingCode;
  final int productPackingCode;
  final bool isIndividual;
  final TextEditingController consultedProductController;
  ConsultedProductWidget({
    Key? key,
    required this.countingCode,
    required this.consultedProductController,
    required this.productPackingCode,
    required this.isIndividual,
  }) : super(key: key);

  @override
  State<ConsultedProductWidget> createState() => ConsultedProductWidgetState();
}

class ConsultedProductWidgetState extends State<ConsultedProductWidget> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  addQuantity({
    required bool isSubtract,
    required InventoryProvider inventoryProvider,
  }) async {
    double quantity = double.tryParse(
        widget.consultedProductController.text.replaceAll(RegExp(r','), '.'))!;

    if (quantity >= 10000) {
      //se a quantidade digitada for maior que 10.000, vai abrir um alertDialog pra confirmar a quantidade
      ShowAlertDialog().showAlertDialog(
        context: context,
        title: 'Deseja confirmar a quantidade?',
        subtitle: isSubtract
            ? 'Quantidade digitada: -${quantity.toStringAsFixed(3)}'
            : 'Quantidade digitada: ${quantity.toStringAsFixed(3)}',
        function: () async {
          await inventoryProvider.addQuantity(
            consultedProductController: widget.consultedProductController,
            isIndividual: widget.isIndividual,
            context: context,
            codigoInternoInvCont: widget.countingCode,
            isSubtract: isSubtract,
          );
        },
      );
    } else {
      //se a quantidade digitada for menor do que 10.000, vai adicionar direto a quantidade, sem o alertDialog pra confirmar
      await inventoryProvider.addQuantity(
        consultedProductController: widget.consultedProductController,
        isIndividual: widget.isIndividual,
        context: context,
        codigoInternoInvCont: widget.countingCode,
        isSubtract: isSubtract,
      );
    }
  }

  anullQuantity(
    InventoryProvider inventoryProvider,
  ) async {
    FocusScope.of(context).unfocus();
    print("ts");
    if (inventoryProvider.products[0].quantidadeInvContProEmb == -1) {
      ShowErrorMessage.showErrorMessage(
        error: "A quantidade já está nula!",
        context: context,
      );
      return;
    }

    ShowAlertDialog().showAlertDialog(
      context: context,
      title: "Deseja realmente anular a quantidade?",
      function: () async {
        await inventoryProvider.anullQuantity(
          countingCode: widget.countingCode,
          productPackingCode: inventoryProvider.products[0].codigoInternoProEmb,
          context: context,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    InventoryProvider inventoryProvider = Provider.of(context, listen: true);

    return PersonalizedCard.personalizedCard(
      context: context,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            TitleAndSubtitle.titleAndSubtitle(
              title: "Produto",
              value: inventoryProvider.products[0].productName,
              fontSize: 20,
            ),
            TitleAndSubtitle.titleAndSubtitle(
              title: "PLU",
              value: inventoryProvider.products[0].plu,
              fontSize: 20,
            ),
            TitleAndSubtitle.titleAndSubtitle(
              title: "Qtd contada",
              value: inventoryProvider.products[0].quantidadeInvContProEmb == -1
                  //quando o valor está nulo, eu coloco como "-1" pra tratar um bug
                  ? 'Sem contagem'
                  : ConvertString.convertToBrazilianNumber(
                      inventoryProvider.products[0].quantidadeInvContProEmb,
                    ),
              fontSize: 20,
            ),
            if (inventoryProvider.lastQuantityAdded != 0)
              const SizedBox(height: 3),
            if (inventoryProvider.lastQuantityAdded != 0)
              FittedBox(
                child: Text(
                  inventoryProvider.lastQuantityAdded != 0
                      ? 'Última quantidade adicionada:  ${inventoryProvider.lastQuantityAdded.toStringAsFixed(3).replaceAll(RegExp(r'\.'), ',')} '
                      : 'Última quantidade adicionada:  ${inventoryProvider.lastQuantityAdded.toStringAsFixed(3).replaceAll(RegExp(r'\.'), ',')} ',
                  style: TextStyle(
                    fontSize: 100,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'BebasNeue',
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1,
                    wordSpacing: 4,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            const SizedBox(height: 8),
            if (!widget.isIndividual)
              AddSubtractOrAnullWidget(
                addButtonText: "SOMAR",
                subtractButtonText: "SUBTRAIR",
                isUpdatingQuantity: inventoryProvider.isLoadingQuantity,
                addQuantityFunction: () async {
                  await addQuantity(
                    isSubtract: false,
                    inventoryProvider: inventoryProvider,
                  );
                },
                subtractQuantityFunction: () async {
                  await addQuantity(
                    isSubtract: true,
                    inventoryProvider: inventoryProvider,
                  );
                },
                anullFunction: () async {
                  await anullQuantity(
                    inventoryProvider,
                  );
                },
                isLoading: inventoryProvider.isLoadingQuantity ? true : false,
                consultedProductController: widget.consultedProductController,
                consultedProductFormKey: _formKey,
                consultedProductFocusNode:
                    inventoryProvider.consultedProductFocusNode,
              ),
            if (widget.isIndividual)
              InsertOneQuantity(
                isIndividual: widget.isIndividual,
                codigoInternoInvCont: widget.countingCode,
                consultedProductController: widget.consultedProductController,
              ),
          ],
        ),
      ),
    );
  }
}
