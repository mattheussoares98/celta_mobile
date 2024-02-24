import 'package:celta_inventario/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';

class ResearchConcurrentPricesPage extends StatefulWidget {
  const ResearchConcurrentPricesPage({Key? key}) : super(key: key);

  @override
  State<ResearchConcurrentPricesPage> createState() =>
      _ResearchConcurrentPricesPageState();
}

class _ResearchConcurrentPricesPageState
    extends State<ResearchConcurrentPricesPage> {
  final TextEditingController _searchResearchsController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchResearchsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResearchPricesProvider researchPricesProvider =
        Provider.of(context, listen: true);
    // Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return PopScope(
      canPop: true,
      onPopInvoked: (_) async {},
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'PREÇOS CONCORRENTES',
          ),
          leading: IconButton(
            onPressed: () {
              researchPricesProvider.clearResearchPrices();
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
            ),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SearchWidget(
              focusNodeConsultProduct:
                  researchPricesProvider.researchPricesFocusNode,
              isLoading: researchPricesProvider.isLoadingResearchPrices,
              onPressSearch: () async {
                await researchPricesProvider.getResearchPrices(context);

                //não estava funcionando passar o productsCount como parâmetro
                //para o "SearchProductWithEanPluOrNameWidget" para apagar o
                //textEditingController após a consulta dos produtos se encontrar
                //algum produto
                if (researchPricesProvider.researchPricesCount > 0) {
                  //se for maior que 0 significa que deu certo a consulta e
                  //por isso pode apagar o que foi escrito no campo de
                  //consulta
                  _searchResearchsController.clear();
                }
              },
              consultProductController: _searchResearchsController,
            ),
            if (researchPricesProvider.isLoadingResearchPrices)
              Expanded(
                child: SearchingWidget(
                  title: 'Consultando pesquisas de preço',
                ),
              ),
            if (researchPricesProvider.errorGetResearchPrices != "" &&
                researchPricesProvider.researchPricesCount == 0)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ErrorMessage(
                    errorMessage: researchPricesProvider.errorGetResearchPrices),
              ),
            Container(),
            // if (!researchPricesProvider.isLoadingResearchPrices)
            // PriceConferenceItems(
            //   researchPricesProvider: researchPricesProvider,
            //   internalEnterpriseCode: arguments["CodigoInterno_Empresa"],
            // ),
            // if (MediaQuery.of(context).viewInsets.bottom == 0 &&
            //     researchPricesProvider.researchPricesCount > 1)
            //   //só mostra a opção de organizar se houver mais de um produto e se o teclado estiver fechado
            //   PriceConferenceOrderProductsButtons(
            //       researchPricesProvider: researchPricesProvider)
          ],
        ),
      ),
    );
  }
}
