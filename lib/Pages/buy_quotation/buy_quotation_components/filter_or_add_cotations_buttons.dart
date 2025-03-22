import 'package:flutter/material.dart';

import '../../../Models/models.dart';
import '../../../utils/utils.dart';

class FilterOrAddCotationsButtons extends StatelessWidget {
  final void Function() updateShowFilterOptions;
  final bool showFilterOptions;
  final EnterpriseModel enterprise;

  const FilterOrAddCotationsButtons({
    required this.updateShowFilterOptions,
    required this.showFilterOptions,
    required this.enterprise,
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
            onPressed: () {
              Navigator.of(context).pushNamed(
                APPROUTES.BUY_QUOTATION_INSERT_UPDATE,
                arguments: {
                  "enterprise": enterprise,
                  "isInserting": true,
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
