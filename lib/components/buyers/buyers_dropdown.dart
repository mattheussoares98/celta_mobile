import 'package:flutter/material.dart';

import '../../models/soap/soap.dart';

class BuyersDropDown extends StatelessWidget {
  final GlobalKey<FormFieldState> dropdownKey;
  final String disabledHintText;
  final List<BuyerModel> buyers;
  final BuyerModel? value;
  final String? Function(BuyerModel?)? validator;
  final void Function(BuyerModel?)? onChanged;
  final void Function()? reloadBuyers;
  final void Function() onTap;
  final bool showRefreshIcon;

  const BuyersDropDown({
    required this.value,
    required this.dropdownKey,
    required this.disabledHintText,
    required this.buyers,
    required this.onChanged,
    required this.reloadBuyers,
    required this.showRefreshIcon,
    required this.onTap,
    this.validator,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: DropdownButtonFormField<BuyerModel>(
              key: dropdownKey,
              value: value,
              disabledHint: Center(child: Text(disabledHintText)),
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              isExpanded: true,
              hint: Center(
                child: Text(
                  disabledHintText,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              validator: validator,
              onChanged: onChanged,
              items: buyers
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      alignment: Alignment.center,
                      onTap: onTap,
                      child: FittedBox(
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                value.Name,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        if (showRefreshIcon)
          IconButton(
            onPressed: reloadBuyers,
            tooltip: "Pesquisar compradores novamente",
            icon: Icon(
              Icons.refresh,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
      ],
    );
  }
}
