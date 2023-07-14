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

class InventoryProductsItems extends StatefulWidget {
  final int countingCode;
  final int productPackingCode;
  final bool isIndividual;
  final TextEditingController consultedProductController;
  InventoryProductsItems({
    Key? key,
    required this.countingCode,
    required this.consultedProductController,
    required this.productPackingCode,
    required this.isIndividual,
  }) : super(key: key);

  @override
  State<InventoryProductsItems> createState() => InventoryProductsItemsState();
}

class InventoryProductsItemsState extends State<InventoryProductsItems> {
  addQuantity({
    required bool isSubtract,
    required InventoryProvider inventoryProvider,
    required int indexOfProduct,
  }) async {
    double quantity = double.tryParse(
        widget.consultedProductController.text.replaceAll(RegExp(r','), '.'))!;

    if (quantity >= 10000) {
      //se a quantidade digitada for maior que 10.000, vai abrir um alertDialog pra confirmar a quantidade
      ShowAlertDialog().showAlertDialog(
        confirmMessageSize: 300,
        cancelMessageSize: 300,
        context: context,
        title: 'Deseja confirmar a quantidade?',
        subtitle: isSubtract
            ? 'Quantidade digitada: -${quantity.toStringAsFixed(3)}'
            : 'Quantidade digitada: ${quantity.toStringAsFixed(3)}',
        function: () async {
          await inventoryProvider.addQuantity(
            indexOfProduct: indexOfProduct,
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
        indexOfProduct: indexOfProduct,
        consultedProductController: widget.consultedProductController,
        isIndividual: widget.isIndividual,
        context: context,
        codigoInternoInvCont: widget.countingCode,
        isSubtract: isSubtract,
      );
    }
  }

  anullQuantity({
    required InventoryProvider inventoryProvider,
    required int index,
  }) async {
    FocusScope.of(context).unfocus();
    if (inventoryProvider.products[index].quantidadeInvContProEmb == -1) {
      ShowErrorMessage.showErrorMessage(
        error: "A quantidade já está nula!",
        context: context,
      );
      return;
    }

    ShowAlertDialog().showAlertDialog(
      confirmMessageSize: 300,
      cancelMessageSize: 300,
      context: context,
      title: "Deseja realmente anular a quantidade?",
      function: () async {
        await inventoryProvider.anullQuantity(
          indexOfProduct: index,
          countingCode: widget.countingCode,
          productPackingCode:
              inventoryProvider.products[index].codigoInternoProEmb,
          context: context,
        );
      },
    );
  }

  changeFocusToConsultedProductFocusNode({
    required InventoryProvider inventoryProvider,
  }) {
    Future.delayed(const Duration(milliseconds: 300), () {
      //se não colocar em um future pra mudar o foco,
      //não funciona corretamente
      FocusScope.of(context).requestFocus(
        inventoryProvider.consultedProductFocusNode,
      );
    });
  }

  selectIndexAndFocus({
    required InventoryProvider inventoryProvider,
    required int index,
  }) {
    if (inventoryProvider.productsCount == 1 ||
        inventoryProvider.isLoadingProducts ||
        inventoryProvider.isLoadingQuantity) {
      return;
    }

    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      if (inventoryProvider.consultedProductFocusNode.hasFocus &&
          MediaQuery.of(context).viewInsets.bottom == 0) {
        FocusScope.of(context).unfocus();
        changeFocusToConsultedProductFocusNode(
          inventoryProvider: inventoryProvider,
        );
      }
      if (!inventoryProvider.consultedProductFocusNode.hasFocus) {
        changeFocusToConsultedProductFocusNode(
          inventoryProvider: inventoryProvider,
        );
      }
      return;
    }

    if (_selectedIndex == index) {
      if (!inventoryProvider.consultedProductFocusNode.hasFocus) {
        changeFocusToConsultedProductFocusNode(
          inventoryProvider: inventoryProvider,
        );
      } else {
        setState(() {
          _selectedIndex = -1;
        });
      }
    }
  }

  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    InventoryProvider inventoryProvider = Provider.of(context, listen: true);

    return Expanded(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: inventoryProvider.productsCount,
                itemBuilder: (context, index) {
                  if (inventoryProvider.productsCount == 1) {
                    _selectedIndex = index;
                  }
                  return GestureDetector(
                    onTap: () {
                      selectIndexAndFocus(
                        inventoryProvider: inventoryProvider,
                        index: index,
                      );
                    },
                    child: PersonalizedCard.personalizedCard(
                      context: context,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            TitleAndSubtitle.titleAndSubtitle(
                              title: "Produto",
                              value:
                                  inventoryProvider.products[index].productName,
                              fontSize: 20,
                            ),
                            TitleAndSubtitle.titleAndSubtitle(
                              title: "PLU",
                              value: inventoryProvider.products[index].plu,
                              fontSize: 20,
                            ),
                            TitleAndSubtitle.titleAndSubtitle(
                              title: "Qtd contada",
                              value: inventoryProvider.products[index]
                                          .quantidadeInvContProEmb ==
                                      -1
                                  //quando o valor está nulo, eu coloco como "-1" pra tratar um bug
                                  ? 'Sem contagem'
                                  : ConvertString.convertToBrazilianNumber(
                                      inventoryProvider.products[index]
                                          .quantidadeInvContProEmb,
                                    ),
                              subtitleColor: inventoryProvider.products[index]
                                          .quantidadeInvContProEmb !=
                                      -1
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.error,
                              otherWidget: Icon(
                                _selectedIndex != index
                                    ? Icons.arrow_drop_down_sharp
                                    : Icons.arrow_drop_up_sharp,
                                color: Theme.of(context).colorScheme.primary,
                                size: 30,
                              ),
                              fontSize: 20,
                            ),
                            if (inventoryProvider.lastQuantityAdded != 0 &&
                                _selectedIndex == index &&
                                inventoryProvider.indexOfLastAddedQuantity ==
                                    index)
                              const SizedBox(height: 3),
                            if (inventoryProvider.lastQuantityAdded != 0 &&
                                _selectedIndex == index &&
                                inventoryProvider.indexOfLastAddedQuantity ==
                                    index)
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: FittedBox(
                                  child: Text(
                                    'Última quantidade adicionada:  ${inventoryProvider.lastQuantityAdded.toStringAsFixed(3).replaceAll(RegExp(r'\.'), ',')}',
                                    style: TextStyle(
                                      fontSize: 100,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'BebasNeue',
                                      fontStyle: FontStyle.italic,
                                      letterSpacing: 1,
                                      wordSpacing: 4,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 8),
                            if (!widget.isIndividual && _selectedIndex == index)
                              AddSubtractOrAnullWidget(
                                addButtonText: "SOMAR",
                                subtractButtonText: "SUBTRAIR",
                                isUpdatingQuantity:
                                    inventoryProvider.isLoadingQuantity,
                                addQuantityFunction: () async {
                                  await addQuantity(
                                    indexOfProduct: index,
                                    isSubtract: false,
                                    inventoryProvider: inventoryProvider,
                                  );
                                },
                                subtractQuantityFunction: () async {
                                  await addQuantity(
                                    indexOfProduct: index,
                                    isSubtract: true,
                                    inventoryProvider: inventoryProvider,
                                  );
                                },
                                anullFunction: () async {
                                  await anullQuantity(
                                    inventoryProvider: inventoryProvider,
                                    index: index,
                                  );
                                },
                                isLoading: inventoryProvider.isLoadingQuantity
                                    ? true
                                    : false,
                                consultedProductController:
                                    widget.consultedProductController,
                                consultedProductFocusNode:
                                    inventoryProvider.consultedProductFocusNode,
                              ),
                            if (widget.isIndividual && _selectedIndex == index)
                              InsertOneQuantity(
                                isIndividual: widget.isIndividual,
                                codigoInternoInvCont: widget.countingCode,
                                consultedProductController:
                                    widget.consultedProductController,
                                indexOfProduct: index,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
