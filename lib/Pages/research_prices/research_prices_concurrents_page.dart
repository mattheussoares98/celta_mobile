import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
import '../../providers/providers.dart';
import '../../components/research_prices/research_prices.dart';
import '../../utils/utils.dart';

class ResearchPricesConcurrentsPage extends StatefulWidget {
  const ResearchPricesConcurrentsPage({Key? key}) : super(key: key);

  @override
  State<ResearchPricesConcurrentsPage> createState() => _ResearchPricesConcurrentsPageState();
}

class _ResearchPricesConcurrentsPageState extends State<ResearchPricesConcurrentsPage> {
  Future<void> _getConcurrents({
    required bool notifyListenersFromUpdate,
    required ResearchPricesProvider researchPricesProvider,
  }) async {
    await researchPricesProvider.getConcurrents(
      context: context,
      notifyListenersFromUpdate: notifyListenersFromUpdate,
    );
  }

  bool _isLoaded = false;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    ResearchPricesProvider researchPricesProvider =
        Provider.of(context, listen: true);

    if (!_isLoaded) {
      await _getConcurrents(
        notifyListenersFromUpdate: false,
        researchPricesProvider: researchPricesProvider,
      );
    }

    _isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    ResearchPricesProvider researchPricesProvider =
        Provider.of(context, listen: true);

    return PopScope(
      canPop: true,
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
          actions: [
            IconButton(
              onPressed: researchPricesProvider.isLoadingAddOrUpdateConcurrents
                  ? null
                  : () async {
                      await _getConcurrents(
                        notifyListenersFromUpdate: true,
                        researchPricesProvider: researchPricesProvider,
                      );
                    },
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await _getConcurrents(
              notifyListenersFromUpdate: true,
              researchPricesProvider: researchPricesProvider,
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              if (researchPricesProvider.isLoadingAddOrUpdateConcurrents)
                Expanded(
                  child: SearchingWidget(
                    title: 'Pesquisando concorrentes',
                  ),
                ),
              if (researchPricesProvider.concurrentsCount > 0)
                const ConcurrentsItems(),
              if (researchPricesProvider.errorAddOrUpdateConcurrents != "" &&
                  researchPricesProvider.concurrentsCount == 0)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ErrorMessage(
                      errorMessage:
                          researchPricesProvider.errorAddOrUpdateConcurrents),
                ),
            ],
          ),
        ),
        floatingActionButton: floatingPersonalizedButton(
            context: context,
            researchPricesProvider: researchPricesProvider,
            nextRoute: APPROUTES.RESEARCH_PRICES_INSERT_UPDATE_RESEARCH_PRICE,
            isLoading: researchPricesProvider.isLoadingAddOrUpdateConcurrents,
            messageButton: "criar\nconcorrente".toUpperCase(),
            onTap: () {
              researchPricesProvider.updateSelectedConcurrent(null);
              Navigator.of(context)
                  .pushNamed(APPROUTES.RESERACH_PRICE_INSERT_UPDATE_CONCORRENT);
            }),
      ),
    );
  }
}