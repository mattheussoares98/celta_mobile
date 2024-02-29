import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
import '../../providers/providers.dart';

class ConcurrentsPage extends StatefulWidget {
  const ConcurrentsPage({Key? key}) : super(key: key);

  @override
  State<ConcurrentsPage> createState() => _ConcurrentsPageState();
}

class _ConcurrentsPageState extends State<ConcurrentsPage> {
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
    // Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return PopScope(
      canPop: true,
      onPopInvoked: (_) async {},
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'CONCORRENTES',
          ),
          leading: IconButton(
            onPressed: () {
              researchPricesProvider.clearConcurrents();
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
            ElevatedButton(
              onPressed: () async {
                await _getConcurrents(
                  notifyListenersFromUpdate: true,
                  researchPricesProvider: researchPricesProvider,
                );
              },
              child: const Text("Consultar novamente"),
            ),
            if (researchPricesProvider.isLoadingConcurrents)
              Expanded(
                child: SearchingWidget(
                  title: 'Pesquisando concorrentes',
                ),
              ),
            if (researchPricesProvider.errorConcurrents != "" &&
                researchPricesProvider.concurrentsCount == 0)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ErrorMessage(
                    errorMessage: researchPricesProvider.errorConcurrents),
              ),
            // if (!researchPricesProvider.isLoadingConcurrents)
            // PriceConferenceItems(
            //   researchPricesProvider: researchPricesProvider,
            //   internalEnterpriseCode: arguments["CodigoInterno_Empresa"],
            // ),
            // if (MediaQuery.of(context).viewInsets.bottom == 0 &&
            //     researchPricesProvider.concurrentsCount > 1)
            //   //só mostra a opção de organizar se houver mais de um produto e se o teclado estiver fechado
            //   PriceConferenceOrderProductsButtons(
            //       researchPricesProvider: researchPricesProvider)
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          tooltip: "Nova pesquisa de preços",
          backgroundColor: researchPricesProvider.isLoadingConcurrents
              ? Colors.grey.withOpacity(0.75)
              : Colors.red.withOpacity(0.75),
          onPressed: () {},
        ),
      ),
    );
  }
}
