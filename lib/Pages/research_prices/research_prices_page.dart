import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';
import '../../components/global_widgets/global_widgets.dart';
import '../../components/research_prices/research_prices.dart';
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
    await researchPricesProvider.getResearchPrices(
      context: context,
      notifyListenersFromUpdate: notityListenersFromUpdate,
      enterpriseCode: enterpriseCode!,
    );
  }

  bool _isLoaded = false;
  int? enterpriseCode;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (!_isLoaded) {
      Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
      enterpriseCode = arguments["CodigoInterno_Empresa"];
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

    return PopScope(
      canPop: !researchPricesProvider.isLoadingResearchPrices &&
          !researchPricesProvider.isLoadingAddOrUpdateConcurrents,
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
            onPressed: researchPricesProvider.isLoadingResearchPrices ||
                    researchPricesProvider.isLoadingAddOrUpdateConcurrents
                ? null
                : () {
                    researchPricesProvider.clearResearchPrices();
                    Navigator.of(context).pop();
                  },
            icon: const Icon(
              Icons.arrow_back_outlined,
            ),
          ),
          actions: [
            IconButton(
              onPressed: researchPricesProvider.isLoadingResearchPrices ||
                      researchPricesProvider.isLoadingAddOrUpdateConcurrents
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
        body: RefreshIndicator(
          onRefresh: () async {
            await _getResearchPrices(
              notityListenersFromUpdate: true,
              researchPricesProvider: researchPricesProvider,
            );
          },
          child: Column(
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
              if (!researchPricesProvider.isLoadingResearchPrices)
                ResearchPricesItems(enterpriseCode: enterpriseCode!),
            ],
          ),
        ),
        floatingActionButton: floatingPersonalizedButton(
            context: context,
            researchPricesProvider: researchPricesProvider,
            nextRoute: APPROUTES.RESEARCH_PRICES_INSERT_UPDATE_RESEARCH_PRICE,
            isLoading: researchPricesProvider.isLoadingResearchPrices,
            messageButton: "criar\npesquisa".toUpperCase(),
            onTap: () async {
              researchPricesProvider.updateSelectedResearch(null);
              final createdNewResearch = await Navigator.of(context).pushNamed(
                APPROUTES.RESEARCH_PRICES_INSERT_UPDATE_RESEARCH_PRICE,
                arguments: {"enterpriseCode": enterpriseCode},
              );

              if (createdNewResearch == true) {
                await _getResearchPrices(
                  notityListenersFromUpdate: true,
                  researchPricesProvider: researchPricesProvider,
                );
              }
            }),
      ),
    );
  }
}
