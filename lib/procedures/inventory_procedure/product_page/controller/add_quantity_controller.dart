import 'package:celta_inventario/procedures/inventory_procedure/provider/quantity_provider.dart';
import 'package:celta_inventario/utils/show_error_message.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../product_provider.dart';

class AddQuantityController {
  static _addLastQuantity({
    required ProductProvider productProvider,
    required bool isSubtract,
    required dynamic quantity,
    required bool isIndividual,
  }) {
    if (!isIndividual &&
        productProvider.products[0].quantidadeInvContProEmb == -1) {
      //quando fica nulo, deixei pra ficar com o valor de -1 para corrigir um bug
      productProvider.products[0].quantidadeInvContProEmb = double.tryParse(
          quantity.text.toString().replaceAll(RegExp(r','), '.'))!;
      return;
    }

    if (isIndividual &&
        productProvider.products[0].quantidadeInvContProEmb == -1) {
      //quando fica nulo, deixei pra ficar com o valor de -1 para corrigir um bug
      productProvider.products[0].quantidadeInvContProEmb = 1;
    } else if (isIndividual) {
      //se for individual, pode somar 1 na última quantidade adicionada
      productProvider.products[0].quantidadeInvContProEmb++;
    } else {
      //se não for individual nem subtração, vai cair aqui
      //precisei sobrescrever a vírgula por ponto senão ocorria erro para somar/subtrair fracionado
      productProvider.products[0].quantidadeInvContProEmb += double.tryParse(
          quantity.text.toString().replaceAll(RegExp(r','), '.'))!;
    }
  }

  static _subtractLastQuantity({
    required ProductProvider productProvider,
    required bool isSubtract,
    required dynamic quantity,
    required bool isIndividual,
  }) {
    if (productProvider.products[0].quantidadeInvContProEmb == -1) {
      return;
    }

    if (isIndividual &&
        productProvider.products[0].quantidadeInvContProEmb > 0) {
      //se for inserção individual e o valor final for >= 0 pode subtrair uma unidade
      productProvider.products[0].quantidadeInvContProEmb--;
      return;
    }

    //se o resultado da subtração for maior ou igual a 0,
    //vai subtrair o valor atual pelo valor digitado
    if ((productProvider.products[0].quantidadeInvContProEmb -
            double.tryParse(quantity.text)!) >=
        0) {
      //como não resultou num valor abaixo de 0, pode atualizar o valor da "quantidade contada"
      productProvider.products[0].quantidadeInvContProEmb -=
          double.tryParse(quantity.text)!;
    }
  }

  static addQuantity({
    required bool isIndividual,
    required BuildContext context,
    required int countingCode,
    required dynamic
        quantity, //coloquei como dynamic porque pode ser um controller ou somente o valor direto, como no caso de quando está inserindo os produtos individualmente que precisa inserir direto a quantidade "1"
    required bool isSubtract,
    void Function()? alterFocusToConsultedProduct,
  }) async {
    QuantityProvider quantityProvider = Provider.of(context, listen: false);
    ProductProvider productProvider = Provider.of(context, listen: false);

    try {
      await quantityProvider.entryQuantity(
        countingCode: countingCode,
        productPackingCode: productProvider.products[0].codigoInternoProEmb,
        quantity: isIndividual ? '1' : quantity.text,
        userIdentity: UserIdentity.identity,
        isSubtract: isSubtract,
      );

      //só vai chegar nessa parte do código se der certo a requisição de atualização da quantidade
      if (isSubtract) {
        _subtractLastQuantity(
            productProvider: productProvider,
            isSubtract: isSubtract,
            quantity: quantity,
            isIndividual: isIndividual);
      } else {
        _addLastQuantity(
            productProvider: productProvider,
            isSubtract: isSubtract,
            quantity: quantity,
            isIndividual: isIndividual);
      }
    } catch (e) {
      e;
    }
    if (quantityProvider.errorMessage != '') {
      ShowErrorMessage().showErrorMessage(
        error: quantityProvider.errorMessage,
        context: context,
      );
      alterFocusToConsultedProduct!();
      return;
    }

    if (!isIndividual) {
      quantity.clear();
    }

    if (!isIndividual) {
      alterFocusToConsultedProduct!();
    }
  }
}
