import 'package:celta_inventario/providers/buy_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LastSavedRequests extends StatefulWidget {
  const LastSavedRequests({Key? key}) : super(key: key);

  @override
  State<LastSavedRequests> createState() => _LastSavedRequestsState();
}

class _LastSavedRequestsState extends State<LastSavedRequests> {
  @override
  void initState() {
    super.initState();
    _updateExpandLastRequestSavedNumbers();
  }

  void _updateExpandLastRequestSavedNumbers() {
    BuyRequestProvider buyRequestProvider = Provider.of(context, listen: false);
    buyRequestProvider.expandLastRequestSavedNumbers =
        buyRequestProvider.lastRequestSavedNumber != "";
  }

  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context);

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(
          color: Color.fromARGB(232, 238, 238, 238),
        ),
      ),
      child: Column(
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                buyRequestProvider.expandLastRequestSavedNumbers =
                    !buyRequestProvider.expandLastRequestSavedNumbers;
              });
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    buyRequestProvider.expandLastRequestSavedNumbers
                        ? "Ocultar últimos pedidos salvos"
                        : "Exibir últimos pedidos salvos",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  buyRequestProvider.expandLastRequestSavedNumbers
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                )
              ],
            ),
          ),
          if (buyRequestProvider.expandLastRequestSavedNumbers)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(color: Colors.black26),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Visibility(
              visible: buyRequestProvider.expandLastRequestSavedNumbers,
              child: buyRequestProvider.lastRequestSavedNumber != ""
                  ? Text(
                      buyRequestProvider.lastRequestSavedNumber,
                      style: const TextStyle(
                        fontFamily: "BebasNeue",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  : const Text(
                      "Não foram encontrados pedidos",
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
