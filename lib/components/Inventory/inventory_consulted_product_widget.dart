import 'package:celta_inventario/Components/Global_widgets/add_subtract_or_anull_widget.dart';
import 'package:celta_inventario/Components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/components/Global_widgets/personalized_card.dart';
import 'package:celta_inventario/Components/Global_widgets/show_error_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/inventory_product_provider.dart';
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
    required InventoryProductProvider inventoryProductProvider,
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
          await inventoryProductProvider.addQuantity(
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
      await inventoryProductProvider.addQuantity(
        consultedProductController: widget.consultedProductController,
        isIndividual: widget.isIndividual,
        context: context,
        codigoInternoInvCont: widget.countingCode,
        isSubtract: isSubtract,
      );
    }
  }

  anullQuantity(
    InventoryProductProvider inventoryProductProvider,
  ) async {
    FocusScope.of(context).unfocus();
    print("ts");
    if (inventoryProductProvider.products[0].quantidadeInvContProEmb == -1) {
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
        await inventoryProductProvider.anullQuantity(
          countingCode: widget.countingCode,
          productPackingCode:
              inventoryProductProvider.products[0].codigoInternoProEmb,
          context: context,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    InventoryProductProvider inventoryProductProvider =
        Provider.of(context, listen: true);

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
              value: inventoryProductProvider.products[0].productName,
              fontSize: 20,
            ),
            TitleAndSubtitle.titleAndSubtitle(
              title: "PLU",
              value: inventoryProductProvider.products[0].plu,
              fontSize: 20,
            ),
            TitleAndSubtitle.titleAndSubtitle(
              title: "Quantidade contada",
              value: inventoryProductProvider
                          .products[0].quantidadeInvContProEmb ==
                      double
                  ? double.tryParse(inventoryProductProvider
                          .products[0].quantidadeInvContProEmb
                          .toString())!
                      .toStringAsFixed(3)
                      .replaceAll(RegExp(r'\.'), ',')
                  : inventoryProductProvider
                              .products[0].quantidadeInvContProEmb ==
                          -1
                      //quando o valor está nulo, eu coloco como "-1" pra tratar um bug
                      ? 'Sem contagem'
                      : double.tryParse(inventoryProductProvider
                              .products[0].quantidadeInvContProEmb
                              .toString())!
                          .toStringAsFixed(3)
                          .replaceAll(RegExp(r'\.'), ','),
              fontSize: 20,
            ),
            if (inventoryProductProvider.lastQuantityAdded != '')
              const SizedBox(height: 3),
            if (inventoryProductProvider.lastQuantityAdded != '')
              FittedBox(
                child: Text(
                  inventoryProductProvider.lastQuantityAdded != 0
                      ? 'Última quantidade adicionada:  ${inventoryProductProvider.lastQuantityAdded.toStringAsFixed(3).replaceAll(RegExp(r'\.'), ',')} '
                      : 'Última quantidade adicionada:  ${inventoryProductProvider.lastQuantityAdded.toStringAsFixed(3).replaceAll(RegExp(r'\.'), ',')} ',
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
                isUpdatingQuantity: inventoryProductProvider.isLoadingQuantity,
                addQuantityFunction: () async {
                  await addQuantity(
                    isSubtract: false,
                    inventoryProductProvider: inventoryProductProvider,
                  );
                },
                subtractQuantityFunction: () async {
                  await addQuantity(
                    isSubtract: true,
                    inventoryProductProvider: inventoryProductProvider,
                  );
                },
                anullFunction: () async {
                  await anullQuantity(
                    inventoryProductProvider,
                  );
                },
                isLoading:
                    inventoryProductProvider.isLoadingQuantity ? true : false,
                consultedProductController: widget.consultedProductController,
                consultedProductFormKey: _formKey,
                consultedProductFocusNode:
                    inventoryProductProvider.consultedProductFocusNode,
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
