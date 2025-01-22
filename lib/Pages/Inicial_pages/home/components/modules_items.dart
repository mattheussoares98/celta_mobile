import 'package:flutter/material.dart';

import '../../../../components/components.dart';
import '../../../../utils/utils.dart';

class ModulesItems {
  ModulesItems._();

  static List<Widget> modules = [
    ImageComponent.image(
      imagePath: 'lib/assets/Images/adjustPrice.png',
      routine: 'Alteração de preços'.toUpperCase(),
      nextRoute: APPROUTES.ADJUST_SALE_PRICE_PRODUCTS,
      context: NavigatorKey.navigatorKey.currentState!.context,
    ),
    ImageComponent.image(
      imagePath: 'lib/assets/Images/adjustStock.png',
      routine: 'Ajuste de estoque'.toUpperCase(),
      nextRoute: APPROUTES.ADJUST_STOCK,
      context: NavigatorKey.navigatorKey.currentState!.context,
    ),
    // ImageComponent.image(
    //   imagePath: 'lib/assets/Images/LogoCeltaTransparente.png',
    //   routine: 'Avaliação e sugestôes'.toUpperCase(),
    //   context: NavigatorKey.navigatorKey.currentState!.context,

    //   moduleIsLiberated: true,
    // ),
    ImageComponent.image(
      imagePath: 'lib/assets/Images/newClient.png',
      routine: 'Cadastro de clientes'.toUpperCase(),
      context: NavigatorKey.navigatorKey.currentState!.context,
      onlyForValidateModule: true,
      nextRoute: APPROUTES.CUSTOMER_REGISTER,
    ),
    ImageComponent.image(
      imagePath: 'lib/assets/Images/productsConference.png',
      routine: 'Conferência de produtos (expedição)'.toUpperCase(),
      nextRoute: APPROUTES.EXPEDITION_CONFERENCE_CONTROLS_TO_CONFERENCE,
      context: NavigatorKey.navigatorKey.currentState!.context,
    ),
    ImageComponent.image(
      imagePath: 'lib/assets/Images/consultPrice.png',
      routine: 'Consulta de preços'.toUpperCase(),
      nextRoute: APPROUTES.PRICE_CONFERENCE,
      context: NavigatorKey.navigatorKey.currentState!.context,
    ),
    ImageComponent.image(
      imagePath: 'lib/assets/Images/buyQuotation.png',
      routine: 'Cotação de compras'.toUpperCase(),
      nextRoute: APPROUTES.BUY_QUOTATION,
      context: NavigatorKey.navigatorKey.currentState!.context,
      isNew: true,
    ),
    ImageComponent.image(
      imagePath: 'lib/assets/Images/inventory.png',
      routine: 'Inventário'.toUpperCase(),
      nextRoute: APPROUTES.INVENTORY,
      context: NavigatorKey.navigatorKey.currentState!.context,
    ),
    ImageComponent.image(
      imagePath: 'lib/assets/Images/buyRequest.png',
      routine: 'Pedido de compras'.toUpperCase(),
      nextRoute: APPROUTES.BUYERS,
      context: NavigatorKey.navigatorKey.currentState!.context,
      onlyForValidateModule: true,
    ),
    ImageComponent.image(
      imagePath: 'lib/assets/Images/transfer.png',
      routine: 'Pedido de transferência'.toUpperCase(),
      nextRoute: APPROUTES.TRANSFER_REQUEST_MODEL,
      context: NavigatorKey.navigatorKey.currentState!.context,
      onlyForValidateModule: true,
    ),
    ImageComponent.image(
      imagePath: 'lib/assets/Images/saleRequest.png',
      routine: 'Pedido de vendas'.toUpperCase(),
      nextRoute: APPROUTES.SALE_REQUEST_MODEL,
      context: NavigatorKey.navigatorKey.currentState!.context,
    ),
    ImageComponent.image(
      imagePath: 'lib/assets/Images/searchConcurrentPrice.png',
      routine: 'Preços concorrentes'.toUpperCase(),
      nextRoute: APPROUTES.RESEARCH_PRICES,
      context: NavigatorKey.navigatorKey.currentState!.context,
    ),
    ImageComponent.image(
      imagePath: 'lib/assets/Images/receipt.jpg',
      routine: 'Recebimento de mercadorias'.toUpperCase(),
      nextRoute: APPROUTES.RECEIPT,
      context: NavigatorKey.navigatorKey.currentState!.context,
    ),

    ImageComponent.image(
      imagePath: 'lib/assets/Images/transferBetweenStocks.png',
      routine: 'Transferência entre estoques'.toUpperCase(),
      nextRoute: APPROUTES.TRANSFER_BETWEEN_STOCK,
      context: NavigatorKey.navigatorKey.currentState!.context,
    ),
    // ImageComponent.image(
    //   imagePath: 'lib/assets/Images/transferBetweenStocks.jpg',
    //   routine: 'Transferência entre embalagens'.toUpperCase(),
    //   nextRoute: APPROUTES.TRANSFER_BETWEEN_PACKAGE,
    //   context: NavigatorKey.navigatorKey.currentState!.context,
    // ),
  ];
}
