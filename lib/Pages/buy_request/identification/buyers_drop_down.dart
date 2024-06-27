import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/providers.dart';
import 'identification.dart';

class BuyersDropwodn extends StatefulWidget {
  final GlobalKey<FormFieldState> buyersKey;
  final bool enabledChangeBuyer;
  final bool showRefreshIcon;
  const BuyersDropwodn({
    required this.buyersKey,
    this.enabledChangeBuyer = true,
    this.showRefreshIcon = true,
    Key? key,
  }) : super(key: key);

  @override
  State<BuyersDropwodn> createState() =>
      _BuyersDropwodnState();
}

class _BuyersDropwodnState extends State<BuyersDropwodn> {
  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context);
    return Row(
      children: [
        Expanded(
          child: Card(
            shape: const RoundedRectangleBorder(),
            child: PersonalizedDropdownFormfield(
              onChanged: widget.enabledChangeBuyer == false ? null : (value) {},
              value: buyRequestProvider.selectedBuyer?.Name,
              dropdownKey: widget.buyersKey,
              isLoading: buyRequestProvider.isLoadingBuyer,
              disabledHintText: "Comprador",
              isLoadingMessage: "Consultando compradores",
              validator: (value) {
                if (value == null) {
                  return "Selecione o comprador";
                }

                return null;
              },
              items: buyRequestProvider.buyers
                  .map(
                    (value) => DropdownMenuItem(
                      value: value.Name,
                      alignment: Alignment.center,
                      onTap: () {
                        buyRequestProvider.selectedBuyer = value;
                      },
                      child: FittedBox(
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                value.Name,
                              ),
                            ),
                            const Divider(
                              height: 4,
                              color: Colors.black,
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
        if (widget.showRefreshIcon)
          IconButton(
            onPressed: buyRequestProvider.isLoadingBuyer
                ? null
                : () async {
                    widget.buyersKey.currentState?.reset();

                    await buyRequestProvider.getBuyers(
                      isSearchingAgain: true,
                      context: context,
                    );
                  },
            tooltip: "Pesquisar compradores novamente",
            icon: Icon(
              Icons.refresh,
              color: buyRequestProvider.isLoadingBuyer
                  ? Colors.grey
                  : Theme.of(context).colorScheme.primary,
            ),
          ),
      ],
    );
  }
}
