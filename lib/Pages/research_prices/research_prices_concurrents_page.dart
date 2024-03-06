import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
import '../../providers/providers.dart';
import '../../components/research_prices/research_prices.dart';
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
    );
    if (researchPricesProvider.errorGetConcurrents == "") {
      searchConcurrentControllerText.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    ResearchPricesProvider researchPricesProvider =
        Provider.of(context, listen: true);

    return PopScope(
      canPop: !researchPricesProvider.isLoadingGetConcurrents,
      onPopInvoked: (_) async {
        researchPricesProvider.clearConcurrents();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'CONCORRENTES',
          ),
          leading: IconButton(
            onPressed: () {
              researchPricesProvider.updateSelectedConcurrent(null);
              researchPricesProvider.clearConcurrents();
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
            ),
          ),
        ),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SearchWidget(
                    consultProductController: searchConcurrentControllerText,
                    isLoading: researchPricesProvider.isLoadingGetConcurrents,
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
                    onPressed: researchPricesProvider.isLoadingGetConcurrents
                        ? null
                        : () async {
                            _getConcurrents(
                              researchPricesProvider: researchPricesProvider,
                              getAllConcurrents: true,
                            );
                          },
                    child: const Text(
                      "Consultar\ntodos",
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
            if (researchPricesProvider.isLoadingGetConcurrents)
              Expanded(
                child: SearchingWidget(
                  title: 'Pesquisando concorrentes',
                ),
              ),
            if (researchPricesProvider.concurrentsCount > 0)
              const ConcurrentsItems(),
            if (researchPricesProvider.errorGetConcurrents != "")
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ErrorMessage(
                    errorMessage: researchPricesProvider.errorGetConcurrents),
              ),
          ],
        ),
        floatingActionButton: floatingPersonalizedButton(
          context: context,
          researchPricesProvider: researchPricesProvider,
          nextRoute: APPROUTES.RESEARCH_PRICES_INSERT_UPDATE_RESEARCH_PRICE,
          isLoading: researchPricesProvider.isLoadingGetConcurrents,
          messageButton: "criar\nconcorrente".toUpperCase(),
          onTap: () {
            researchPricesProvider.updateSelectedConcurrent(null);
            Navigator.of(context)
                .pushNamed(APPROUTES.RESERACH_PRICE_INSERT_UPDATE_CONCORRENT);
          },
        ),
      ),
    );
  }
}
