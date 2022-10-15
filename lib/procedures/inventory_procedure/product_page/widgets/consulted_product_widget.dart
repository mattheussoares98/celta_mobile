import 'package:celta_inventario/components/personalized_card.dart';
import 'package:celta_inventario/procedures/inventory_procedure/provider/quantity_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../product_provider.dart';
import 'anull_quantity_button.dart';
import 'confirm_quantity_button.dart';
import 'insert_one_quantity.dart';

class ConsultedProductWidget extends StatefulWidget {
  final int countingCode;
  final int productPackingCode;
  final bool isIndividual;
  final bool? isLoadingEanOrPlu;
  ConsultedProductWidget({
    Key? key,
    required this.countingCode,
    required this.productPackingCode,
    required this.isIndividual,
    this.isLoadingEanOrPlu,
  }) : super(key: key);

  @override
  State<ConsultedProductWidget> createState() => ConsultedProductWidgetState();
}

class ConsultedProductWidgetState extends State<ConsultedProductWidget> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static final TextEditingController _consultedProductController =
      TextEditingController();

  final _consultedProductFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _consultedProductFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of(context, listen: true);
    QuantityProvider quantityProvider = Provider.of(context, listen: true);

    double? lastQuantityAdded =
        double.tryParse(quantityProvider.lastQuantityAdded);

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
                    productProvider.products[0].productName.length > 26
                        //se o nome do produto tiver mais de 26 caracteres, vai ficar ruim a exibição somente em uma linha, aí ele quebra a linha no 26º caracter
                        ? productProvider.products[0].productName.replaceRange(
                                26,
                                productProvider.products[0].productName.length,
                                '\n') +
                            productProvider.products[0].productName
                                .substring(26)
                                .replaceFirst(
                                  RegExp(r'\('),
                                  '\n\(',
                                )
                        : productProvider.products[0].productName,
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
                  productProvider.products[0].plu,
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
                      productProvider.products[0].quantidadeInvContProEmb ==
                              double
                          ? double.tryParse(productProvider
                                  .products[0].quantidadeInvContProEmb
                                  .toString())!
                              .toStringAsFixed(3)
                              .replaceAll(RegExp(r'\.'), ',')
                          : productProvider
                                      .products[0].quantidadeInvContProEmb ==
                                  -1
                              //quando o valor está nulo, eu coloco como "-1" pra tratar um bug
                              ? 'Sem contagem'
                              : double.tryParse(productProvider
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
            if (quantityProvider.lastQuantityAdded != '')
              const SizedBox(height: 3),
            if (quantityProvider.lastQuantityAdded != '')
              FittedBox(
                child: Text(
                  quantityProvider.isSubtract &&
                          quantityProvider.isConfirmedQuantity
                      ? 'Última quantidade adicionada:  -${lastQuantityAdded!.toStringAsFixed(3).replaceAll(RegExp(r'\.'), ',')} '
                      : 'Última quantidade adicionada:  ${lastQuantityAdded!.toStringAsFixed(3).replaceAll(RegExp(r'\.'), ',')} ',
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
                              enabled: quantityProvider.isLoadingQuantity
                                  ? false
                                  : true,
                              controller: _consultedProductController,
                              focusNode: _consultedProductFocusNode,
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
                                } else if (value.contains('..')) {
                                  return 'Carácter inválido';
                                } else if (value.contains(',,')) {
                                  return 'Carácter inválido';
                                } else if (value.contains('..')) {
                                  return 'Carácter inválido';
                                } else if (value.contains(',.')) {
                                  return 'Carácter inválido';
                                } else if (value.contains('.,')) {
                                  return 'Carácter inválido';
                                } else if (value.contains('-')) {
                                  return 'Carácter inválido';
                                } else if (value.contains(' ')) {
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
                          child: AnullQuantityButton(
                            countingCode: widget.countingCode,
                            productPackingCode:
                                productProvider.products[0].codigoInternoProEmb,
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
                        child: ConfirmQuantityButton(
                          isIndividual: widget.isIndividual,
                          consultedProductController:
                              _consultedProductController,
                          countingCode: widget.countingCode,
                          isSubtract: true,
                          formKey: _formKey,
                          consultedProductFocusNode: _consultedProductFocusNode,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        flex: 5,
                        child: ConfirmQuantityButton(
                          isIndividual: widget.isIndividual,
                          consultedProductController:
                              _consultedProductController,
                          countingCode: widget.countingCode,
                          isSubtract: false,
                          formKey: _formKey,
                          consultedProductFocusNode: _consultedProductFocusNode,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            if (widget.isIndividual)
              InsertOneQuantity(
                isIndividual: widget.isIndividual,
                countingCode: widget.countingCode,
                consultedProductController: _consultedProductController,
              ),
          ],
        ),
      ),
    );
  }
}
