import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import 'buy_quotation.dart';

class InsertUpdateBuyQuotationPage extends StatefulWidget {
  const InsertUpdateBuyQuotationPage({super.key});

  @override
  State<InsertUpdateBuyQuotationPage> createState() =>
      _InsertUpdateBuyQuotationPageState();
}

class _InsertUpdateBuyQuotationPageState
    extends State<InsertUpdateBuyQuotationPage> {
  bool showEditObservationFormField = false;
  final observationsController = TextEditingController();
  static String? newObservation;
  final observationsFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        // {
        //     "enterprise": enterprise,
        //     "incompleteQuotation": incompleteQuotation,
        //   }
        EnterpriseProvider enterpriseProvider =
            Provider.of(context, listen: false);
        BuyQuotationProvider buyQuotationProvider =
            Provider.of(context, listen: false);

        await loadCompleteBuyQuotation();

        buyQuotationProvider.updateSelectedsValues(enterpriseProvider);

        if (buyQuotationProvider
                .completeBuyQuotation?.Observations?.isNotEmpty ==
            true) {
          observationsController.text =
              buyQuotationProvider.completeBuyQuotation!.Observations!;
        }
      }
    });
  }

  @override
  dispose() {
    super.dispose();
    observationsController.dispose();
    observationsFocusNode.dispose();
  }

  Future<void> loadCompleteBuyQuotation() async {
    Map? arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    BuyQuotationIncompleteModel? incompleteModel =
        arguments?["incompleteQuotation"];

    EnterpriseModel? enterprise = arguments?["enterprise"];
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

  void updateObservation() {
    setState(() {
      newObservation = observationsController.text;
      showEditObservationFormField = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    BuyQuotationProvider buyQuotationProvider = Provider.of(context);
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
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (buyQuotationProvider.completeBuyQuotation == null)
                    TextButton(
                      onPressed: () async {
                        await loadCompleteBuyQuotation();
                      },
                      child: const Text("Pesquisar novamente"),
                    ),
                  if (buyQuotationProvider.completeBuyQuotation != null)
                    Column(
                      children: [
                        SimpleInformations(
                          observationsController: observationsController,
                          newObservation: newObservation,
                          observationsFocusNode: observationsFocusNode,
                          showEditObservationFormField:
                              showEditObservationFormField,
                          updateObservation: updateObservation,
                          updateShowEditObservationFormField: () {
                            setState(() {
                              showEditObservationFormField =
                                  !showEditObservationFormField;
                            });
                            observationsFocusNode.requestFocus();
                          },
                        ),
                        const Divider(),
                        const Enterprises(),
                        const Divider(),
                        const Products(),
                      ],
                    ),
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
