import 'package:flutter/material.dart';

import '../../../../components/components.dart';
import '../../../../utils/utils.dart';

class ModulesItems extends StatelessWidget {
  final String? manualsUrl;
  const ModulesItems({
    required this.manualsUrl,
    super.key,
  });

  int returnSize(BuildContext context) {
    if (MediaQuery.of(context).size.width > 900) {
      return 4;
    } else if (MediaQuery.of(context).size.width > 600) {
      return 3;
    } else
      return 2;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: returnSize(context), // define o número de colunas
      childAspectRatio: 1.7, // define a proporção de largura/altura dos itens
      mainAxisSpacing: 0.0,
      crossAxisSpacing: 0.0,
      shrinkWrap: true,
      children: [
        ImageComponent.image(
          imagePath: 'lib/assets/Images/adjustPrice.png',
          routine: 'Alteração de preços'.toUpperCase(),
          nextRoute: APPROUTES.ADJUST_SALE_PRICE_PRODUCTS,
          context: context,
        ),
        ImageComponent.image(
          imagePath: 'lib/assets/Images/adjustStock.png',
          routine: 'Ajuste de estoque'.toUpperCase(),
          nextRoute: APPROUTES.ADJUST_STOCK,
          context: context,
        ),
        // ImageComponent.image(
        //   imagePath: 'lib/assets/Images/LogoCeltaTransparente.png',
        //   routine: 'Avaliação e sugestôes'.toUpperCase(),
        //   context: context,

        //   moduleIsLiberated: true,
        // ),
        ImageComponent.image(
          imagePath: 'lib/assets/Images/newClient.png',
          routine: 'Cadastro de clientes'.toUpperCase(),
          context: context,
          onlyForValidateModule: true,
          nextRoute: APPROUTES.CUSTOMER_REGISTER,
        ),
        ImageComponent.image(
          imagePath: 'lib/assets/Images/productsConference.png',
          routine: 'Conferência de produtos (expedição)'.toUpperCase(),
          nextRoute: APPROUTES.EXPEDITION_CONFERENCE_CONTROLS_TO_CONFERENCE,
          context: context,
        ),
        ImageComponent.image(
          imagePath: 'lib/assets/Images/consultPrice.png',
          routine: 'Consulta de preços'.toUpperCase(),
          nextRoute: APPROUTES.PRICE_CONFERENCE,
          context: context,
        ),
        ImageComponent.image(
          imagePath: 'lib/assets/Images/buyQuotation.png',
          routine: 'Cotação de compras'.toUpperCase(),
          nextRoute: APPROUTES.BUY_QUOTATION,
          context: context,
          isNew: true,
        ),
        ImageComponent.image(
          imagePath: 'lib/assets/Images/inventory.png',
          routine: 'Inventário'.toUpperCase(),
          nextRoute: APPROUTES.INVENTORY,
          context: context,
        ),
        ImageComponent.image(
          imagePath: 'lib/assets/Images/manuals.png',
          routine: 'Manuais'.toUpperCase(),
          nextRoute: APPROUTES.MANUALS,
          context: context,
          isNew: true,
          onTap: () async {
            // await UrlLauncher.searchAndLaunchUrl(
            //   context: context,
            //   url: 'https://www.celtaware.com.br',
            // );
          },
        ),
        ImageComponent.image(
          imagePath: 'lib/assets/Images/buyRequest.png',
          routine: 'Pedido de compras'.toUpperCase(),
          nextRoute: APPROUTES.BUYERS,
          context: context,
          onlyForValidateModule: true,
        ),
        ImageComponent.image(
          imagePath: 'lib/assets/Images/transfer.png',
          routine: 'Pedido de transferência'.toUpperCase(),
          nextRoute: APPROUTES.TRANSFER_REQUEST_MODEL,
          context: context,
          onlyForValidateModule: true,
        ),
        ImageComponent.image(
          imagePath: 'lib/assets/Images/saleRequest.png',
          routine: 'Pedido de vendas'.toUpperCase(),
          nextRoute: APPROUTES.SALE_REQUEST_MODEL,
          context: context,
        ),
        ImageComponent.image(
          imagePath: 'lib/assets/Images/searchConcurrentPrice.png',
          routine: 'Preços concorrentes'.toUpperCase(),
          nextRoute: APPROUTES.RESEARCH_PRICES,
          context: context,
        ),
        ImageComponent.image(
          imagePath: 'lib/assets/Images/receipt.jpg',
          routine: 'Recebimento de mercadorias'.toUpperCase(),
          nextRoute: APPROUTES.RECEIPT,
          context: context,
        ),

        ImageComponent.image(
          imagePath: 'lib/assets/Images/transferBetweenStocks.png',
          routine: 'Transferência entre estoques'.toUpperCase(),
          nextRoute: APPROUTES.TRANSFER_BETWEEN_STOCK,
          context: context,
        ),
        // ImageComponent.image(
        //   imagePath: 'lib/assets/Images/transferBetweenStocks.jpg',
        //   routine: 'Transferência entre embalagens'.toUpperCase(),
        //   nextRoute: APPROUTES.TRANSFER_BETWEEN_PACKAGE,
        //   context: context,
        // ),
      ],
    );
  }
}
