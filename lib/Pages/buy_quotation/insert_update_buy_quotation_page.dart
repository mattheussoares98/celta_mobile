import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';

class InsertUpdateBuyQuotationPage extends StatefulWidget {
  const InsertUpdateBuyQuotationPage({super.key});

  @override
  State<InsertUpdateBuyQuotationPage> createState() =>
      _InsertUpdateBuyQuotationPageState();
}

class _InsertUpdateBuyQuotationPageState
    extends State<InsertUpdateBuyQuotationPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        Map? arguments = ModalRoute.of(context)?.settings.arguments as Map?;
        BuyQuotationIncompleteModel? incompleteModel =
            arguments?["incompleteQuotation"];
        EnterpriseModel? enterprise = arguments?["enterprise"];
        // {
        //     "enterprise": enterprise,
        //     "incompleteQuotation": incompleteQuotation,
        //   }

        if (incompleteModel == null || enterprise == null) {
          return;
        }

        BuyQuotationProvider buyQuotationProvider =
            Provider.of(context, listen: false);

        await buyQuotationProvider.getBuyQuotation(
          context: context,
          valueToSearch: incompleteModel.Code.toString(),
          searchByPersonalizedCode: false,
          enterpriseCode: enterprise.Code,
          complete: true,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    BuyQuotationProvider buyQuotationProvider =
        Provider.of(context, listen: false);
    Map? arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    BuyQuotationIncompleteModel? incompleteModel =
        arguments?["incompleteQuotation"];
    // EnterpriseModel? enterprise = arguments?["enterprise"];

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(incompleteModel == null ? "Inserindo" : "Alterando"),
          ),
        ),
        loadingWidget(buyQuotationProvider.isLoading),
      ],
    );
  }
}
