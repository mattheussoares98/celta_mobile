import 'package:flutter/material.dart';

import '../../components/components.dart';
import 'components/components.dart';

class BuyQuotationPage extends StatefulWidget {
  const BuyQuotationPage({super.key});

  @override
  State<BuyQuotationPage> createState() => _BuyQuotationPageState();
}

class _BuyQuotationPageState extends State<BuyQuotationPage> {
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();
  bool? searchByPersonalizedCode;
  bool? searchByCode;
  DateTime? initialDateOfCreation;
  DateTime? finalDateOfCreation;
  DateTime? initialDateOfLimit;
  DateTime? finalDateOfLimit;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    searchFocusNode.dispose();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consulta de cotações"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchWidget(
              searchProductController: searchController,
              onPressSearch: () {},
              searchFocusNode: searchFocusNode,
              hintText:
                  searchByCode == true ? "Código" : "Código personalizado",
              labelText:
                  searchByCode == true ? "Código" : "Código personalizado",
            ),
            Row(
              children: [
                Expanded(
                  child: CheckBoxPersonalized(
                    enabled: searchByCode == true,
                    searchType: "Código",
                    updateEnabled: updateSearchByCode,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CheckBoxPersonalized(
                    enabled: searchByPersonalizedCode == true,
                    searchType: "Código personalizado",
                    updateEnabled: updateSearchByPersonalizedCode,
                  ),
                ),
              ],
            ),
            DateFilters(
              initialDateOfCreation: initialDateOfCreation,
              finalDateOfCreation: finalDateOfCreation,
              initialDateOfLimit: initialDateOfLimit,
              finalDateOfLimit: finalDateOfLimit,
              callSetState: () {
                setState(() {});
              },
              updateInitialDateOfCreation: (DateTime? date) {
                if (date != null) {
                  initialDateOfCreation = date;
                } else {
                  initialDateOfCreation = null;
                }
              },
              updateFinalDateOfCreation: (DateTime? date) {
                if (date != null) {
                  finalDateOfCreation = date;
                } else {
                  finalDateOfCreation = null;
                }
              },
              updateInitialDateOfLimit: (DateTime? date) {
                if (date != null) {
                  initialDateOfLimit = date;
                } else {
                  initialDateOfLimit = null;
                }
              },
              updateFinalDateOfLimit: (DateTime? date) {
                if (date != null) {
                  finalDateOfLimit = date;
                } else {
                  finalDateOfLimit = null;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
