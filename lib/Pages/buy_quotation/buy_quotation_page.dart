import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../models/configurations/configurations.dart';
import '../../models/enterprise/enterprise.dart';
import '../../providers/providers.dart';
import 'components/components.dart';

class BuyQuotationPage extends StatefulWidget {
  const BuyQuotationPage({super.key});

  @override
  State<BuyQuotationPage> createState() => _BuyQuotationPageState();
}

class _BuyQuotationPageState extends State<BuyQuotationPage> {
  final searchController = TextEditingController();
  final searchProductController = TextEditingController();
  final searchSupplierController = TextEditingController();
  final searchFocusNode = FocusNode();
  final searchProductFocusNode = FocusNode();
  final searchSupplierFocusNode = FocusNode();
  // final GlobalKey<FormFieldState> buyersKey = GlobalKey();
  bool searchByPersonalizedCode = true;
  bool searchByCode = false;
  DateTime? initialDateOfCreation;
  DateTime? finalDateOfCreation;
  DateTime? initialDateOfLimit;
  DateTime? finalDateOfLimit;
  bool inclusiveExpired = false;

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
          searchByPersonalizedCode: searchByPersonalizedCode,
          initialDateOfCreation: initialDateOfCreation,
          finalDateOfCreation: finalDateOfCreation,
          initialDateOfLimit: initialDateOfLimit,
          finalDateOfLimit: finalDateOfLimit,
          enterpriseCode: enterprise.Code,
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    searchProductController.dispose();
    searchSupplierController.dispose();
    searchFocusNode.dispose();
    searchProductFocusNode.dispose();
    searchSupplierFocusNode.dispose();
  }

  void updateSearchByCode() {
    if (searchByPersonalizedCode == true) {
      setState(() {
        searchByPersonalizedCode = false;
        searchByCode = true;
      });
    } else {
      setState(() {
        searchByCode = true;
      });
    }
  }

  void updateSearchByPersonalizedCode() {
    if (searchByCode == true) {
      setState(() {
        searchByCode = false;
        searchByPersonalizedCode = true;
      });
    } else {
      setState(() {
        searchByPersonalizedCode = true;
      });
    }
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
            title: const FittedBox(child: Text("Consulta de cotações")),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SearchWidget(
                    searchProductController: searchController,
                    onPressSearch: () {},
                    searchFocusNode: searchFocusNode,
                    configurations: [
                      ConfigurationType.legacyCode,
                      ConfigurationType.personalizedCode,
                    ],
                    hintText: searchByCode == true
                        ? "Código"
                        : "Código personalizado",
                    labelText: searchByCode == true
                        ? "Código"
                        : "Código personalizado",
                  ),
                  SearchByCodeOrPersonalizedCode(
                    searchByCode: searchByCode,
                    updateSearchByCode: updateSearchByCode,
                    searchByPersonalizedCode: searchByPersonalizedCode,
                    updateSearchByPersonalizedCode:
                        updateSearchByPersonalizedCode,
                  ),
                  const SizedBox(height: 8),
                  DateFilters(
                    initialDateOfCreation: initialDateOfCreation,
                    finalDateOfCreation: finalDateOfCreation,
                    initialDateOfLimit: initialDateOfLimit,
                    finalDateOfLimit: finalDateOfLimit,
                    callSetState: () {
                      setState(() {});
                    },
                    updateInitialDateOfCreation: (DateTime? date) {
                      initialDateOfCreation = date;
                    },
                    updateFinalDateOfCreation: (DateTime? date) {
                      finalDateOfCreation = date;
                    },
                    updateInitialDateOfLimit: (DateTime? date) {
                      initialDateOfLimit = date;
                    },
                    updateFinalDateOfLimit: (DateTime? date) {
                      finalDateOfLimit = date;
                    },
                  ),
                  const SizedBox(height: 8),
                  InclusiveExpiredCheckbox(
                    inclusiveExpired: inclusiveExpired,
                    updateInclusiveExpired: () {
                      setState(() {
                        inclusiveExpired = !inclusiveExpired;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  FilterProduct(
                    searchProductFocusNode: searchProductFocusNode,
                    searchProductController: searchProductController,
                    enterprise: enterprise,
                  ),
                  const SizedBox(height: 8),
                  FilterSupplier(
                    searchSupplierFocusNode: searchSupplierFocusNode,
                    searchSupplierController: searchSupplierController,
                    enterprise: enterprise,
                  ),
                  // const SizedBox(height: 8),
                  // FilterBuyer(buyersKey: buyersKey),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      await buyQuotationProvider.getBuyQuotation(
                        context: context,
                        valueToSearch: searchProductController.text,
                        searchByPersonalizedCode: searchByPersonalizedCode,
                        initialDateOfCreation: initialDateOfCreation,
                        finalDateOfCreation: finalDateOfCreation,
                        initialDateOfLimit: initialDateOfLimit,
                        finalDateOfLimit: finalDateOfLimit,
                        enterpriseCode: enterprise.Code,
                      );
                    },
                    child: const Text(
                      "Pesquisar",
                    ),
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
