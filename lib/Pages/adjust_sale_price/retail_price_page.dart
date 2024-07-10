import 'package:flutter/material.dart';

import '../../components/global_widgets/global_widgets.dart';

class RetailPricePage extends StatelessWidget {
  const RetailPricePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Varejo"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SearchWidget(
            focusNodeConsultProduct: FocusNode(),
            showOnlyConfigurationOfSearch: true,
            isLoading: false,
            onPressSearch: () async {
              // await priceConferenceProvider.getProduct(
              //   configurationsProvider: configurationsProvider,
              //   enterpriseCode: enterprise.codigoInternoEmpresa,
              //   controllerText: _consultProductController.text,
              //   context: context,
              // );

              //não estava funcionando passar o productsCount como parâmetro
              //para o "SearchProductWithEanPluOrNameWidget" para apagar o
              //textEditingController após a consulta dos produtos se encontrar
              //algum produto
              // if (priceConferenceProvider.productsCount > 0) {
              //   //se for maior que 0 significa que deu certo a consulta e
              //   //por isso pode apagar o que foi escrito no campo de
              //   //consulta
              //   _consultProductController.clear();
              // }
            },
            consultProductController: TextEditingController(),
          ),
          // if (priceConferenceProvider.errorMessage != "" &&
          //     priceConferenceProvider.productsCount == 0)
          //   Expanded(
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: ErrorMessage(
          //           errorMessage: priceConferenceProvider.errorMessage),
          //     ),
          //   ),
          // if (!priceConferenceProvider.isLoading &&
          //     priceConferenceProvider.products.isNotEmpty)
          //   ProductItems(
          //     priceConferenceProvider: priceConferenceProvider,
          //     internalEnterpriseCode: enterprise.codigoInternoEmpresa,
          //   ),
          // if (MediaQuery.of(context).viewInsets.bottom == 0 &&
          //     priceConferenceProvider.productsCount > 1)
          //   //só mostra a opção de organizar se houver mais de um produto e se o teclado estiver fechado
          //   PriceConferenceOrderProductsButtons(
          //       priceConferenceProvider: priceConferenceProvider)
        ],
      ),
    );
  }
}
