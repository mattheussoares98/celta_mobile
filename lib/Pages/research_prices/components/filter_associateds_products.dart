import 'package:flutter/material.dart';

class FilterAssociatedsProducts extends StatefulWidget {
  final bool? isAll;
  final bool? withoutCounts;
  final bool? withCounts;
  final void Function(bool?)? changeIsAll;
  final void Function(bool?)? changeWithoutCounts;
  final void Function(bool?)? changeWithCounts;
  const FilterAssociatedsProducts({
    super.key,
    required this.isAll,
    required this.withoutCounts,
    required this.withCounts,
    required this.changeIsAll,
    required this.changeWithoutCounts,
    required this.changeWithCounts,
  });

  @override
  State<FilterAssociatedsProducts> createState() =>
      _ResearchPricesFilterAssociatedsProducts();
}

class _ResearchPricesFilterAssociatedsProducts
    extends State<FilterAssociatedsProducts> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "Filtrar produtos associados à pesquisa",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Card(
            child: FittedBox(
              child: Row(
                children: [
                  CheckboxMenuButton(
                    value: widget.isAll,
                    onChanged: (value) {
                      widget.changeIsAll!(value);
                    },
                    child: const Text("Todos"),
                  ),
                  CheckboxMenuButton(
                    value: widget.withCounts,
                    onChanged: (value) {
                      widget.changeWithCounts!(value);
                    },
                    child: const Text("Preço informado"),
                  ),
                  CheckboxMenuButton(
                    value: widget.withoutCounts,
                    onChanged: (value) {
                      widget.changeWithoutCounts!(value);
                    },
                    child: const Text("Sem preço informado"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
