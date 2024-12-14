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
      body: Column(
        children: [
          SearchWidget(
            searchProductController: searchController,
            onPressSearch: () {},
            searchFocusNode: searchFocusNode,
            hintText: searchByCode == true ? "Código" : "Código personalizado",
            labelText: searchByCode == true ? "Código" : "Código personalizado",
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
        ],
      ),
    );
  }
}
