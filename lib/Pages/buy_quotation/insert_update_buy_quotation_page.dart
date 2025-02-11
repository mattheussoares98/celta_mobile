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
  final observationsController = TextEditingController();
  final observationsFocusNode = FocusNode();
  List<Map<int, TextEditingController>> controllers = [];
  List<Map<int, FocusNode>> focusNodes = [];
  DateTime? dateOfLimit;
  BuyerModel? selectedBuyer;

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
        bool isInserting = arguments?["isInserting"];

        buyQuotationProvider.updateSelectedsValues(
          enterpriseProvider: enterpriseProvider,
          isInserting: isInserting,
        );

        if (buyQuotationProvider
                .selectedBuyQuotation?.Observations?.isNotEmpty ==
            true) {
          observationsController.text =
              buyQuotationProvider.selectedBuyQuotation!.Observations!;
        }

        selectedBuyer = buyQuotationProvider.selectedBuyQuotation?.Buyer;
        if (buyQuotationProvider.selectedBuyQuotation?.DateOfLimit != null) {
          dateOfLimit = DateTime.parse(
              buyQuotationProvider.selectedBuyQuotation!.DateOfLimit!);
        }
        observationsController.text =
            buyQuotationProvider.selectedBuyQuotation?.Observations ?? "";

        createControllersAndFocusNode(buyQuotationProvider);
      }
    });
  }

  void createControllersAndFocusNode(
      BuyQuotationProvider buyQuotationProvider) {
    if (buyQuotationProvider.allEnterprises.isEmpty == true) {
      return;
    } else {
      controllers = buyQuotationProvider.allEnterprises
          .map((e) => {e.Code: TextEditingController()})
          .toList();
      focusNodes = buyQuotationProvider.allEnterprises
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

    EnterpriseModel? enterprise = arguments?["enterprise"];
    bool isInserting = arguments?["isInserting"];

    BuyQuotationProvider buyQuotationProvider =
        Provider.of(context, listen: false);

    await buyQuotationProvider.getBuyers(context: context);

    if (enterprise == null) {
      return;
    }

    if (!isInserting) {
      await buyQuotationProvider.getBuyQuotation(
        context: context,
        valueToSearch:
            buyQuotationProvider.selectedBuyQuotation?.Code.toString() ?? "",
        searchByPersonalizedCode: false,
        enterpriseCode: enterprise.Code,
        complete: isInserting ? false : true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    BuyQuotationProvider buyQuotationProvider = Provider.of(context);
    Map? arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    EnterpriseModel? enterprise = arguments?["enterprise"];
    bool isInserting = arguments?["isInserting"];

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
                dateOfLimit: dateOfLimit,
                buyer: selectedBuyer,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (buyQuotationProvider.selectedBuyQuotation == null &&
                      !isInserting)
                    TextButton(
                      onPressed: () async {
                        await loadCompleteBuyQuotation();
                      },
                      child: const Text("Pesquisar novamente"),
                    ),
                  Column(
                    children: [
                      SimpleInformations(
                        isInserting:
                            buyQuotationProvider.selectedBuyQuotation == null,
                        observationsController: observationsController,
                        observationsFocusNode: observationsFocusNode,
                        dateOfLimit: dateOfLimit,
                        buyer: selectedBuyer,
                        updateBuyer: (buyer) {
                          setState(() {
                            selectedBuyer = buyer;
                          });
                        },
                        updateDateOfLimit: (date) {
                          setState(() {
                            dateOfLimit = date;
                          });
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
