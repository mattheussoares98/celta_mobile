import 'package:celta_inventario/components/Buy_request/buy_request_dropdownformfield.dart';
import 'package:celta_inventario/providers/buy_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuyRequestBuyersDropwodn extends StatefulWidget {
  final GlobalKey<FormFieldState> buyersKey;
  const BuyRequestBuyersDropwodn({
    required this.buyersKey,
    Key? key,
  }) : super(key: key);

  @override
  State<BuyRequestBuyersDropwodn> createState() =>
      _BuyRequestBuyersDropwodnState();
}

class _BuyRequestBuyersDropwodnState extends State<BuyRequestBuyersDropwodn> {
  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Comprador",
          style: TextStyle(
            color: Colors.grey,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Card(
                shape: const RoundedRectangleBorder(),
                child: BuyRequestDropdownFormfield(
                  value: buyRequestProvider.selectedBuyerDropDown,
                  onChanged: (value) {
                    buyRequestProvider.selectedBuyerDropDown = value;
                  },
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
                          value: value.CpfNumber,
                          alignment: Alignment.center,
                          onTap: () {},
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
        ),
      ],
    );
  }
}
