import 'package:flutter/material.dart';

import '../components.dart';

class SearchByCodeOrPersonalizedCode extends StatelessWidget {
  final bool searchByCode;
  final void Function() updateSearchByCode;
  final bool searchByPersonalizedCode;
  final void Function() updateSearchByPersonalizedCode;

  const SearchByCodeOrPersonalizedCode({
    required this.searchByCode,
    required this.updateSearchByCode,
    required this.searchByPersonalizedCode,
    required this.updateSearchByPersonalizedCode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
