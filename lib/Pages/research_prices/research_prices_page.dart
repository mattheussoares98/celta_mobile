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
    required String searchText,
  }) async {
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    await researchPricesProvider.getResearchPrices(
      context: context,
      notifyListenersFromUpdate: notityListenersFromUpdate,
      enterpriseCode: arguments["CodigoInterno_Empresa"],
      searchText: searchText,
    );

    if (researchPricesProvider.errorGetResearchPrices.isEmpty) {
      searchController.text = "";
    }
  }

  FocusNode _focusNode = FocusNode();
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    ResearchPricesProvider researchPricesProvider =
        Provider.of(context, listen: true);

    return PopScope(
      canPop: !researchPricesProvider.isLoadingAddOrUpdateConcurrents,
      onPopInvoked: (_) async {
        researchPricesProvider.clearResearchPrices();
      },
      child: Stack(
        children: [
          Scaffold(
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
                Row(
                  children: [
                    Expanded(
                      child: SearchWidget(
                        consultProductController: searchController,
                        isLoading:
                            researchPricesProvider.isLoadingResearchPrices ||
                                researchPricesProvider
                                    .isLoadingAddOrUpdateOfResearch,
                        onPressSearch: () async {
                          await _getResearchPrices(
                            notityListenersFromUpdate: true,
                            researchPricesProvider: researchPricesProvider,
                            searchText: searchController.text,
                          );
                        },
                        hintText: "Nome ou código",
                        labelText: "Nome ou código",
                        focusNodeConsultProduct: _focusNode,
                        useCamera: false,
                        showConfigurationsIcon: false,
                      ),
                    ),
                    FittedBox(
                      child: TextButton(
                        onPressed:
                            researchPricesProvider.isLoadingGetConcurrents ||
                                    researchPricesProvider
                                        .isLoadingAddOrUpdateOfResearch
                                ? null
                                : () async {
                                    await _getResearchPrices(
                                      notityListenersFromUpdate: true,
                                      researchPricesProvider:
                                          researchPricesProvider,
                                      searchText: "%",
                                    );
                                  },
                        child: Text(
                          "Consultar\ntodas",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: researchPricesProvider
                                        .isLoadingGetConcurrents ||
                                    researchPricesProvider
                                        .isLoadingAddOrUpdateOfResearch
                                ? Colors.grey
                                : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                if (researchPricesProvider.errorGetResearchPrices != "" &&
                    researchPricesProvider.researchPricesCount == 0)
                  ErrorMessage(
                    errorMessage: researchPricesProvider.errorGetResearchPrices,
                  ),
                if (!researchPricesProvider.isLoadingResearchPrices)
                  ResearchPricesItems(
                    enterpriseCode: arguments["CodigoInterno_Empresa"],
                  ),
              ],
            ),
            floatingActionButton: floatingPersonalizedButton(
                context: context,
                researchPricesProvider: researchPricesProvider,
                nextRoute:
                    APPROUTES.RESEARCH_PRICES_INSERT_UPDATE_RESEARCH_PRICE,
                isLoading: researchPricesProvider.isLoadingResearchPrices,
                messageButton: "criar\npesquisa".toUpperCase(),
                onTap: () async {
                  researchPricesProvider.updateSelectedResearch(null);

                  await Navigator.of(context).pushNamed(
                    APPROUTES.RESEARCH_PRICES_INSERT_UPDATE_RESEARCH_PRICE,
                    arguments: {
                      "enterpriseCode": arguments["CodigoInterno_Empresa"],
                    },
                  );

                  // if (createdNewResearch == true) {
                  //   await _getResearchPrices(
                  //     notityListenersFromUpdate: true,
                  //     researchPricesProvider: researchPricesProvider,
                  //     searchControllerText:
                  //   );
                  // }
                }),
          ),
          loadingWidget(
            message: 'Consultando pesquisas de preço...',
            isLoading: researchPricesProvider.isLoadingResearchPrices,
          ),
          loadingWidget(
            message: 'Adicionando/alterando concorrente...',
            isLoading: researchPricesProvider.isLoadingAddOrUpdateConcurrents,
          ),
        ],
      ),
    );
  }
}
