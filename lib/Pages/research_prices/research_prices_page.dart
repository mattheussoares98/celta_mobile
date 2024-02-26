import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
import '../../providers/providers.dart';
import '../../components/research_prices/research_prices.dart';

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
            'PESQUISAS CADASTRADAS',
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
                    errorMessage:
                        researchPricesProvider.errorGetResearchPrices),
              ),
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
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          tooltip: "Nova pesquisa de preços",
          onPressed: () {
            researchPricesModalBottom(
              context: context,
              isNewResearch: true,
              isLoading: researchPricesProvider.isLoadingResearchPrices,
              name: "name",
              observations: "observations",
              researchPricesProvider: researchPricesProvider,
            );
          },
        ),
      ),
    );
  }
}
