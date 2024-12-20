import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../models/enterprise/enterprise.dart';
import '../../providers/providers.dart';
import 'components/components.dart';

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
    });
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

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const FittedBox(child: Text("Cotações")),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FilterOrAddCotationsButtons(
                    updateShowFilterOptions: updateShowFilterOptions,
                    addQuotation: () {},
                    showFilterOptions: showFilterOptions,
                  ),
                  const Divider(),
                  if (showFilterOptions)
                    AllFiltersOptions(enterprise: enterprise),
                ],
              ),
            ),
          ),
        ),
        loadingWidget(buyQuotationProvider.isLoading),
      ],
    );
  }
}
