import 'package:flutter/material.dart';

class FilterOrAddCotationsButtons extends StatelessWidget {
  final void Function() updateShowFilterOptions;
  final void Function() addQuotation;
  final bool showFilterOptions;

  const FilterOrAddCotationsButtons({
    required this.updateShowFilterOptions,
    required this.addQuotation,
    required this.showFilterOptions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton.icon(
            icon: const Icon(Icons.filter_list_alt),
            label: FittedBox(
              child: Text(
                showFilterOptions ? "Ocultar filtros" : "Exibir filtros",
              ),
            ),
            iconAlignment: IconAlignment.end,
            onPressed: updateShowFilterOptions,
          ),
        ),
        Expanded(
          child: TextButton.icon(
            icon: const Icon(Icons.add),
            label: const FittedBox(
              child: Text(
                "Cadastrar cotação",
              ),
            ),
            iconAlignment: IconAlignment.end,
            onPressed: addQuotation,
          ),
        ),
      ],
    );
  }
}
