import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
import '../../providers/providers.dart';
import 'components/components.dart';
import '../../utils/utils.dart';

class ResearchPricesConcurrentsPage extends StatefulWidget {
  const ResearchPricesConcurrentsPage({Key? key}) : super(key: key);

  @override
  State<ResearchPricesConcurrentsPage> createState() =>
      _ResearchPricesConcurrentsPageState();
}

class _ResearchPricesConcurrentsPageState
    extends State<ResearchPricesConcurrentsPage> {
  TextEditingController searchConcurrentControllerText =
      TextEditingController();
  FocusNode focusNodeSearch = FocusNode();

  Future<void> _getConcurrents({
    required ResearchPricesProvider researchPricesProvider,
    required bool getAllConcurrents,
  }) async {
    await researchPricesProvider.getConcurrents(
      searchConcurrentControllerText:
          getAllConcurrents ? "%" : searchConcurrentControllerText.text,
      getAllConcurrents: getAllConcurrents,
    );
    if (researchPricesProvider.errorGetConcurrents == "") {
      searchConcurrentControllerText.text = "";
    }
  }

  @override
  void dispose() {
    super.dispose();

    focusNodeSearch.dispose();
    searchConcurrentControllerText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResearchPricesProvider researchPricesProvider =
        Provider.of(context, listen: true);

    return PopScope(
      canPop: !researchPricesProvider.isLoadingAddOrUpdateConcurrents &&
          !researchPricesProvider.isLoadingAddOrUpdateOfResearch,
      onPopInvoked: (_) async {
        researchPricesProvider.updateSelectedConcurrent(concurrent: null);
        researchPricesProvider.clearConcurrents();
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: FittedBox(
                child: Text(
                  'CONCORRENTES - pesquisa(${researchPricesProvider.selectedResearch!.Code})',
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
                        autofocus: false,
                        consultProductController:
                            searchConcurrentControllerText,
                        isLoading:
                            researchPricesProvider.isLoadingGetConcurrents ||
                                researchPricesProvider
                                    .isLoadingAddOrUpdateOfResearch,
                        onPressSearch: () async {
                          await _getConcurrents(
                            researchPricesProvider: researchPricesProvider,
                            getAllConcurrents: false,
                          );
                        },
                        hintText: "Nome ou código",
                        labelText: "Nome ou código",
                        focusNodeConsultProduct: focusNodeSearch,
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
                                    _getConcurrents(
                                      researchPricesProvider:
                                          researchPricesProvider,
                                      getAllConcurrents: true,
                                    );
                                  },
                        child: Text(
                          "Consultar\ntodos",
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
                if (researchPricesProvider.errorGetConcurrents != "")
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ErrorMessage(
                        errorMessage:
                            researchPricesProvider.errorGetConcurrents),
                  ),
                if (!researchPricesProvider.isLoadingGetConcurrents)
                  const ConcurrentsItems(),
              ],
            ),
            floatingActionButton: floatingPersonalizedButton(
              context: context,
              researchPricesProvider: researchPricesProvider,
              nextRoute: APPROUTES.RESEARCH_PRICES_INSERT_UPDATE_RESEARCH_PRICE,
              isLoading: researchPricesProvider.isLoadingGetConcurrents ||
                  researchPricesProvider.isLoadingAddOrUpdateOfResearch,
              messageButton: "criar\nconcorrente".toUpperCase(),
              onTap: () {
                researchPricesProvider.updateSelectedConcurrent(
                  concurrent: null,
                );
                Navigator.of(context).pushNamed(
                    APPROUTES.RESERACH_PRICE_INSERT_UPDATE_CONCORRENT);
              },
            ),
          ),
          loadingWidget(
            message: 'Pesquisando concorrentes...',
            isLoading: researchPricesProvider.isLoadingGetConcurrents,
          ),
          loadingWidget(
            message: 'Associando concorrente à pesquisa',
            isLoading:
                researchPricesProvider.isLoadingAssociateConcurrentToResearch,
          ),
        ],
      ),
    );
  }
}
