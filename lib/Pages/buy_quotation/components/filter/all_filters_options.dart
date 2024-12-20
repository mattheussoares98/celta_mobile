import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../models/configurations/configurations.dart';
import '../../../../models/enterprise/enterprise.dart';
import '../../../../providers/providers.dart';
import 'filter.dart';

class AllFiltersOptions extends StatefulWidget {
  // final TextEditingController searchController;
  // final TextEditingController searchProductController;
  // final TextEditingController searchSupplierController;
  // final FocusNode searchFocusNode;
  // final FocusNode searchSupplierFocusNode;
  // final FocusNode searchProductFocusNode;
  // final bool searchByCode;
  // final bool searchByPersonalizedCode;
  // final void Function() updateSearchByCode;
  // final void Function() updateSearchByPersonalizedCode;
  // final DateTime? initialDateOfCreation;
  // final DateTime? finalDateOfCreation;
  // final DateTime? initialDateOfLimit;
  // final DateTime? finalDateOfLimit;
  // final void Function(DateTime? date) updateInitialDateOfCreation;
  // final void Function(DateTime? date) updateFinalDateOfCreation;
  // final void Function(DateTime? date) updateInitialDateOfLimit;
  // final void Function(DateTime? date) updateFinalDateOfLimit;
  // final void Function() callSetState;
  // final bool inclusiveExpired;
  final EnterpriseModel enterprise;
  // final void Function() updateInclusiveExpired;
  const AllFiltersOptions({
    required this.enterprise,
    super.key,
  });

  @override
  State<AllFiltersOptions> createState() => _AllFiltersOptionsState();
}

class _AllFiltersOptionsState extends State<AllFiltersOptions> {
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
  bool showFilterOptions = false;

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

    return Column(
      children: [
        SearchWidget(
          searchProductController: searchController,
          onPressSearch: () {},
          searchFocusNode: searchFocusNode,
          configurations: [
            ConfigurationType.legacyCode,
            ConfigurationType.personalizedCode,
          ],
          hintText: searchByCode == true ? "Código" : "Código personalizado",
          labelText: searchByCode == true ? "Código" : "Código personalizado",
        ),
        SearchByCodeOrPersonalizedCode(
          searchByCode: searchByCode,
          updateSearchByCode: updateSearchByCode,
          searchByPersonalizedCode: searchByPersonalizedCode,
          updateSearchByPersonalizedCode: updateSearchByPersonalizedCode,
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
          enterprise: widget.enterprise,
        ),
        const SizedBox(height: 8),
        FilterSupplier(
          searchSupplierFocusNode: searchSupplierFocusNode,
          searchSupplierController: searchSupplierController,
          enterprise: widget.enterprise,
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
              enterpriseCode: widget.enterprise.Code,
            );
          },
          child: const Text(
            "Pesquisar",
          ),
        ),
      ],
    );
  }
}
