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
  List<Map<int, TextEditingController>> controllers = [];
  List<Map<int, FocusNode>> focusNodes = [];

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

        Map? arguments = ModalRoute.of(context)?.settings.arguments as Map?;
        BuyQuotationIncompleteModel? incompleteModel =
            arguments?["incompleteQuotation"];
        bool isInserting = incompleteModel == null;

        buyQuotationProvider.updateSelectedsValues(
          enterpriseProvider: enterpriseProvider,
          isInserting: isInserting,
        );

        if (buyQuotationProvider
                .completeBuyQuotation?.Observations?.isNotEmpty ==
            true) {
          observationsController.text =
              buyQuotationProvider.completeBuyQuotation!.Observations!;
        }

        createControllersAndFocusNode(buyQuotationProvider);
      }
    });
  }

  void createControllersAndFocusNode(
      BuyQuotationProvider buyQuotationProvider) {
    if (buyQuotationProvider.selectedEnterprises.isEmpty == true) {
      return;
    } else {
      controllers = buyQuotationProvider.selectedEnterprises
          .map((e) => {e.Code: TextEditingController()})
          .toList();
      focusNodes = buyQuotationProvider.selectedEnterprises
          .map((e) => {e.Code: FocusNode()})
          .toList();
    }
  }

  void disposeControllersAndFocusNodes() {
    for (var controller in controllers) {
      controller.values.first.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.values.first.dispose();
    }
  }

  @override
  dispose() {
    super.dispose();
    observationsController.dispose();
    observationsFocusNode.dispose();
    disposeControllersAndFocusNodes();
  }

  Future<void> loadCompleteBuyQuotation() async {
    Map? arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    BuyQuotationIncompleteModel? incompleteModel =
        arguments?["incompleteQuotation"];

    EnterpriseModel? enterprise = arguments?["enterprise"];
    bool isInserting = incompleteModel == null;

    BuyQuotationProvider buyQuotationProvider =
        Provider.of(context, listen: false);

    await buyQuotationProvider.getBuyers(context: context);

    if (isInserting || enterprise == null) {
      return;
    }

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
    EnterpriseModel? enterprise = arguments?["enterprise"];
    bool isInserting = incompleteModel == null;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                ShowAlertDialog.show(
                    context: context,
                    title: "Deseja realmente sair?",
                    content: const Text(
                      "Se alguma alteração não foi salva, ela será perdida se você sair da tela",
                    ),
                    function: () {
                      Navigator.of(context).pop();
                    });
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
            title: Text(isInserting ? "Inserindo" : "Alterando"),
            actions: [
              SaveButton(
                isInserting: isInserting,
                observationsController: observationsController,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (buyQuotationProvider.completeBuyQuotation == null &&
                      incompleteModel != null)
                    TextButton(
                      onPressed: () async {
                        await loadCompleteBuyQuotation();
                      },
                      child: const Text("Pesquisar novamente"),
                    ),
                  Column(
                    children: [
                      SimpleInformations(
                        isInserting: isInserting,
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
                      if (enterprise != null)
                        InsertUpdateProductsItems(
                          enterprise: enterprise,
                          controllers: controllers,
                          focusNodes: focusNodes,
                        ),
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
