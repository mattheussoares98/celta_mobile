import 'package:celta_inventario/components/Buy_request/buy_request_dropdownformfield.dart';
import 'package:celta_inventario/providers/buy_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuyRequestRequestsTypeDropdown extends StatefulWidget {
  final GlobalKey<FormFieldState> requestsKey;

  const BuyRequestRequestsTypeDropdown({
    required this.requestsKey,
    Key? key,
  }) : super(key: key);

  @override
  State<BuyRequestRequestsTypeDropdown> createState() =>
      _BuyRequestRequestsTypeDropdownState();
}

class _BuyRequestRequestsTypeDropdownState
    extends State<BuyRequestRequestsTypeDropdown> {
  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Modelo de pedido de compra",
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
                  onChanged: (value) {},
                  value: buyRequestProvider.selectedRequestModel?.Name,
                  dropdownKey: widget.requestsKey,
                  isLoading: buyRequestProvider.isLoadingRequestsType,
                  disabledHintText: "Modelo de pedido",
                  isLoadingMessage: "Consultando modelos",
                  validator: (value) {
                    if (value == null) {
                      return "Selecione o modelo de pedido";
                    }

                    return null;
                  },
                  items: buyRequestProvider.requestsType
                      .map(
                        (value) => DropdownMenuItem(
                          value: value.Name,
                          alignment: Alignment.center,
                          onTap: () {
                            buyRequestProvider.selectedRequestModel = value;
                          },
                          child: FittedBox(
                            child: Column(
                              children: [
                                Center(
                                  child: Text(
                                    value.Name.toString(),
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
              onPressed: buyRequestProvider.isLoadingRequestsType
                  ? null
                  : () async {
                      widget.requestsKey.currentState?.reset();

                      await buyRequestProvider.getRequestsType(
                        context: context,
                        isSearchingAgain: true,
                      );
                    },
              tooltip: "Pesquisar modelos de pedido novamente",
              icon: Icon(
                Icons.refresh,
                color: buyRequestProvider.isLoadingRequestsType
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
