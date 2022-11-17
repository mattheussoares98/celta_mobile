import 'package:celta_inventario/components/personalized_card.dart';
import 'package:celta_inventario/utils/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/inventory_product_provider.dart';
import '../Buttons/inventory_anull_quantity_button.dart';
import '../Buttons/addOrSubtractButton.dart';
import 'inventory_insert_one_quantity.dart';

class ConsultedProductWidget extends StatefulWidget {
  final int countingCode;
  final int productPackingCode;
  final bool isIndividual;
  final bool? isLoadingEanOrPlu;
  final TextEditingController consultedProductController;
  ConsultedProductWidget({
    Key? key,
    required this.countingCode,
    required this.consultedProductController,
    required this.productPackingCode,
    required this.isIndividual,
    this.isLoadingEanOrPlu,
  }) : super(key: key);

  @override
  State<ConsultedProductWidget> createState() => ConsultedProductWidgetState();
}

class ConsultedProductWidgetState extends State<ConsultedProductWidget> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _consultedProductFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _consultedProductFocusNode.dispose();
  }

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
            FittedBox(
              child: Row(
                children: [
                  const Text(
                    'Produto: ',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  //26
                  Text(
                    inventoryProductProvider.products[0].productName.length > 26
                        //se o nome do produto tiver mais de 26 caracteres, vai ficar ruim a exibição somente em uma linha, aí ele quebra a linha no 26º caracter
                        ? inventoryProductProvider.products[0].productName
                                .replaceRange(
                                    26,
                                    inventoryProductProvider
                                        .products[0].productName.length,
                                    '\n') +
                            inventoryProductProvider.products[0].productName
                                .substring(26)
                                .replaceFirst(
                                  RegExp(r'\('),
                                  '\n\(',
                                )
                        : inventoryProductProvider.products[0].productName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'PLU: ',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  inventoryProductProvider.products[0].plu,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //precisei colocar o flexible porque pelo fittedbox não estava funcionando como queria
                const Flexible(
                  flex: 20,
                  child: Text(
                    'Quantidade contada: ',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Flexible(
                  flex: 15,
                  child: FittedBox(
                    child: Text(
                      inventoryProductProvider
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
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ),
                )
              ],
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
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Container(
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              autofocus: true,
                              enabled:
                                  inventoryProductProvider.isLoadingQuantity
                                      ? false
                                      : true,
                              controller: widget.consultedProductController,
                              focusNode: inventoryProductProvider
                                  .consultedProductFocusNode,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10)
                              ],
                              onChanged: (value) {
                                if (value.isEmpty || value == '-') {
                                  value = '0';
                                }
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Digite uma quantidade';
                                } else if (value == '0' ||
                                    value == '0.' ||
                                    value == '0,') {
                                  return 'Digite uma quantidade';
                                } else if (value.contains('.') &&
                                    value.contains(',')) {
                                  return 'Carácter inválido';
                                } else if (value.contains('-')) {
                                  return 'Carácter inválido';
                                } else if (value.contains(' ')) {
                                  return 'Carácter inválido';
                                } else if (value.characters.toList().fold<int>(
                                        0,
                                        (t, e) =>
                                            e == "." ? t + e.length : t + 0) >
                                    1) {
                                  //verifica se tem mais de um ponto
                                  return 'Carácter inválido';
                                } else if (value.characters.toList().fold<int>(
                                        0,
                                        (t, e) =>
                                            e == "," ? t + e.length : t + 0) >
                                    1) {
                                  //verifica se tem mais de uma vírgula
                                  return 'Carácter inválido';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Digite a quantidade aqui',
                                errorStyle: const TextStyle(
                                  fontSize: 17,
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    style: BorderStyle.solid,
                                    width: 2,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    style: BorderStyle.solid,
                                    width: 2,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        flex: 1,
                        child: Container(
                          child: InventoryAnullQuantityButton(
                            countingCode: widget.countingCode,
                            productPackingCode: inventoryProductProvider
                                .products[0].codigoInternoProEmb,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        flex: 2,
                        child: AddOrSubtractButton(
                          isLoading: inventoryProductProvider.isLoadingQuantity,
                          isIndividual: widget.isIndividual,
                          isSubtract: true,
                          formKey: _formKey,
                          consultedProductFocusNode: _consultedProductFocusNode,
                          function: () async {
                            await addQuantity(
                              isSubtract: true,
                              inventoryProductProvider:
                                  inventoryProductProvider,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        flex: 5,
                        child: AddOrSubtractButton(
                          isLoading: inventoryProductProvider.isLoadingQuantity,
                          isIndividual: widget.isIndividual,
                          isSubtract: false,
                          formKey: _formKey,
                          consultedProductFocusNode: _consultedProductFocusNode,
                          function: () async {
                            await addQuantity(
                              isSubtract: false,
                              inventoryProductProvider:
                                  inventoryProductProvider,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
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
