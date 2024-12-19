import 'package:flutter/material.dart';

import '../../../../components/components.dart';
import '../../../../models/configurations/configurations.dart';
import '../../../../models/enterprise/enterprise.dart';

class SearchItemToFilter<T> extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final EnterpriseModel enterprise;
  final String labelSearch;
  final bool showConfigurationsIcon;
  final List<T> items;
  final void Function(T) updateSelectedItem;
  final Widget Function(T) itemWidgetToSelect;
  final T? selectedItem;
  final Future<void> Function() searchItems;
  final String? hintSearch;
  const SearchItemToFilter({
    required this.focusNode,
    required this.controller,
    required this.enterprise,
    required this.labelSearch,
    required this.showConfigurationsIcon,
    required this.items,
    required this.updateSelectedItem,
    required this.itemWidgetToSelect,
    required this.selectedItem,
    required this.searchItems,
    this.hintSearch,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchWidget(
          labelText: labelSearch,
          hintText: hintSearch,
          configurations: [
            ConfigurationType.legacyCode,
            ConfigurationType.personalizedCode,
          ],
          showConfigurationsIcon: showConfigurationsIcon,
          searchProductController: controller,
          onPressSearch: () async {
            await searchItems();

            if (items.isNotEmpty) {
              controller.clear();
            }

            if (items.length > 1) {
              ShowAlertDialog.show(
                  context: context,
                  title: "Selecione um item",
                  insetPadding: const EdgeInsets.symmetric(vertical: 8),
                  contentPadding: const EdgeInsets.all(0),
                  showConfirmAndCancelMessage: false,
                  showCloseAlertDialogButton: true,
                  canCloseClickingOut: false,
                  content: Scaffold(
                    body: ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];

                        return InkWell(
                          onTap: () {
                            updateSelectedItem(item);
                            Navigator.of(context).pop();
                          },
                          child: itemWidgetToSelect(item),
                        );
                      },
                    ),
                  ),
                  function: () async {});
            }
          },
          searchFocusNode: focusNode,
        ),
        if (selectedItem != null) itemWidgetToSelect(selectedItem!),
      ],
    );
  }
}
