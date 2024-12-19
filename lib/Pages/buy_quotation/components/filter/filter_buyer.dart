import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/buyers/buyers.dart';
import '../../../../providers/providers.dart';

class FilterBuyer extends StatelessWidget {
  final GlobalKey<FormFieldState<dynamic>> buyersKey;
  const FilterBuyer({
    required this.buyersKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    BuyQuotationProvider buyQuotationProvider = Provider.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        BuyersDropDown(
          onTap: () {},
          value: buyQuotationProvider.selectedBuyer,
          dropdownKey: buyersKey,
          disabledHintText: "Filtrar comprador",
          buyers: buyQuotationProvider.searchedBuyers,
          onChanged: (value) {
            buyQuotationProvider.updateSelectedBuyer(value);
          },
          reloadBuyers: () async {
            await buyQuotationProvider.searchBuyer(context);
          },
          showRefreshIcon: true,
        ),
        if (buyQuotationProvider.selectedBuyer != null)
          TextButton.icon(
            onPressed: () {
              buyQuotationProvider.updateSelectedBuyer(null);
            },
            label: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete, color: Colors.red),
                const SizedBox(width: 5),
                Text(
                  "Remover filtro do comprador",
                  style: TextStyle(color: Colors.red),
                )
              ],
            ),
          ),
      ],
    );
  }
}
