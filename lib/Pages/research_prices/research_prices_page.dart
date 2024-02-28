import 'package:celta_inventario/providers/research_prices_provider.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
import '../../providers/providers.dart';

class ResearchPricesPage extends StatefulWidget {
  const ResearchPricesPage({Key? key}) : super(key: key);

  @override
  State<ResearchPricesPage> createState() => _ResearchPricesPageState();
}

class _ResearchPricesPageState extends State<ResearchPricesPage> {
  final TextEditingController _searchResearchsController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchResearchsController.dispose();
  }

  Future<void> _getResearchPrices({
    required bool notityListenersFromUpdate,
    required ResearchPricesProvider researchPricesProvider,
  }) async {
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    await researchPricesProvider.getResearchPrices(
      context: context,
      notifyListenersFromUpdate: notityListenersFromUpdate,
      enterpriseCode: arguments["CodigoInterno_Empresa"],
    );
  }

  bool _isLoaded = false;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (!_isLoaded) {
      ResearchPricesProvider researchPricesProvider =
          Provider.of(context, listen: true);
      await _getResearchPrices(
        notityListenersFromUpdate: false,
        researchPricesProvider: researchPricesProvider,
      );
      _isLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    ResearchPricesProvider researchPricesProvider =
        Provider.of(context, listen: true);
    // Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return PopScope(
      canPop: true,
      onPopInvoked: (_) async {
        researchPricesProvider.clearResearchPrices();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const FittedBox(
            child: Text(
              'PESQUISAS CADASTRADAS',
            ),
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
          actions: [
            IconButton(
              onPressed: researchPricesProvider.isLoadingResearchPrices
                  ? null
                  : () async {
                      await _getResearchPrices(
                        notityListenersFromUpdate: true,
                        researchPricesProvider: researchPricesProvider,
                      );
                    },
              tooltip: "Consultar recebimentos",
              icon: const Icon(Icons.refresh),
            ),
          ],
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
        floatingActionButton: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(APPROUTES.INSERT_OR_UPDATE_RESEARCH_PRICE);
          },
          child: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            minRadius: 35,
            maxRadius: 35,
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: FittedBox(
                child: Center(
                  child: Text(
                    "nova\npesquisa",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
