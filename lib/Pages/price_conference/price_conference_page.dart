import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
import '../../components/price_conference/price_conference.dart';
import '../../providers/providers.dart';

class PriceConferencePage extends StatefulWidget {
  const PriceConferencePage({Key? key}) : super(key: key);

  @override
  State<PriceConferencePage> createState() => _PriceConferencePageState();
}

class _PriceConferencePageState extends State<PriceConferencePage> {
  final TextEditingController _consultProductController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _consultProductController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PriceConferenceProvider priceConferenceProvider =
        Provider.of(context, listen: true);
    ConfigurationsProvider configurationsProvider =
        Provider.of(context, listen: true);
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return PopScope(
      canPop: true,
      onPopInvoked: (_) async {
        priceConferenceProvider.clearProducts();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'CONSULTA DE PREÇOS',
          ),
          leading: IconButton(
            onPressed: () {
              priceConferenceProvider.clearProducts();
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
            ),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SearchWidget(
              focusNodeConsultProduct:
                  priceConferenceProvider.consultProductFocusNode,
              isLoading: priceConferenceProvider.isLoading ||
                  priceConferenceProvider.isSendingToPrint,
              onPressSearch: () async {
                await priceConferenceProvider.getProduct(
                  configurationsProvider: configurationsProvider,
                  enterpriseCode: arguments["CodigoInterno_Empresa"],
                  controllerText: _consultProductController.text,
                  context: context,
                );

                //não estava funcionando passar o productsCount como parâmetro
                //para o "SearchProductWithEanPluOrNameWidget" para apagar o
                //textEditingController após a consulta dos produtos se encontrar
                //algum produto
                if (priceConferenceProvider.productsCount > 0) {
                  //se for maior que 0 significa que deu certo a consulta e
                  //por isso pode apagar o que foi escrito no campo de
                  //consulta
                  _consultProductController.clear();
                }
              },
              consultProductController: _consultProductController,
            ),
            if (priceConferenceProvider.isLoading)
              Expanded(
                child: SearchingWidget(
                  title: 'Consultando produtos',
                ),
              ),
            if (priceConferenceProvider.errorMessage != "" &&
                priceConferenceProvider.productsCount == 0)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ErrorMessage(
                    errorMessage: priceConferenceProvider.errorMessage),
              ),
            if (!priceConferenceProvider.isLoading)
              PriceConferenceItems(
                priceConferenceProvider: priceConferenceProvider,
                internalEnterpriseCode: arguments["CodigoInterno_Empresa"],
              ),
            if (MediaQuery.of(context).viewInsets.bottom == 0 &&
                priceConferenceProvider.productsCount > 1)
              //só mostra a opção de organizar se houver mais de um produto e se o teclado estiver fechado
              PriceConferenceOrderProductsButtons(
                  priceConferenceProvider: priceConferenceProvider)
          ],
        ),
      ),
    );
  }
}
