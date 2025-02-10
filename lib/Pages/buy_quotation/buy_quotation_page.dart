import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';

import '../../models/models.dart';
import '../../providers/providers.dart';
import 'buy_quotation_components/buy_quotation_components.dart';

class BuyQuotationPage extends StatefulWidget {
  const BuyQuotationPage({super.key});

  @override
  State<BuyQuotationPage> createState() => _BuyQuotationPageState();
}

class _BuyQuotationPageState extends State<BuyQuotationPage> {
  bool showFilterOptions = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        BuyQuotationProvider buyQuotationProvider =
            Provider.of(context, listen: false);
        EnterpriseModel enterprise =
            ModalRoute.of(context)!.settings.arguments as EnterpriseModel;

        await searchAllBuyQuotations(
          buyQuotationProvider: buyQuotationProvider,
          enterprise: enterprise,
        );
      }
    });
  }

  Future<void> searchAllBuyQuotations({
    required BuyQuotationProvider buyQuotationProvider,
    required EnterpriseModel enterprise,
  }) async {
    await buyQuotationProvider.getBuyQuotation(
      context: context,
      valueToSearch: "%",
      searchByPersonalizedCode: true,
      initialDateOfCreation: null,
      finalDateOfCreation: null,
      initialDateOfLimit: null,
      finalDateOfLimit: null,
      enterpriseCode: enterprise.Code,
    );
  }

  void updateShowFilterOptions() {
    setState(() {
      showFilterOptions = !showFilterOptions;
    });
  }

  @override
  Widget build(BuildContext context) {
    BuyQuotationProvider buyQuotationProvider = Provider.of(context);
    EnterpriseModel enterprise =
        ModalRoute.of(context)!.settings.arguments as EnterpriseModel;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        buyQuotationProvider.doOnPopScreen();
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: const FittedBox(child: Text("Cotações")),
              actions: [
                IconButton(
                  onPressed: () async {
                    searchAllBuyQuotations(
                      buyQuotationProvider: buyQuotationProvider,
                      enterprise: enterprise,
                    );
                  },
                  icon: const Icon(Icons.replay),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(3),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FilterOrAddCotationsButtons(
                      updateShowFilterOptions: updateShowFilterOptions,
                      showFilterOptions: showFilterOptions,
                      enterprise: enterprise,
                    ),
                    const Divider(),
                    if (showFilterOptions)
                      AllFiltersOptions(enterprise: enterprise),
                    BuyQuotationsItems(enterprise: enterprise),
                  ],
                ),
              ),
            ),
          ),
          loadingWidget(buyQuotationProvider.isLoading),
        ],
      ),
    );
  }
}
