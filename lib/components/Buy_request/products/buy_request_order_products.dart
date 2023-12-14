import 'package:celta_inventario/providers/buy_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuyRequestOrderProducts extends StatefulWidget {
  const BuyRequestOrderProducts({Key? key}) : super(key: key);

  @override
  State<BuyRequestOrderProducts> createState() =>
      _BuyRequestOrderProductsState();
}

class _BuyRequestOrderProductsState extends State<BuyRequestOrderProducts> {
  int? _groupValue = -1;
  bool _expanded = false;

  List<_Item> radios(BuyRequestProvider buyRequestProvider) => [
        _Item(
          name: "Empresas em ordem crescente",
          selected: false,
          sort: () => buyRequestProvider.orderUpByEnterprise(),
        ),
        _Item(
          name: "Empresas em ordem decrescente",
          selected: false,
          sort: () => buyRequestProvider.orderDownByEnterprise(),
        ),
        _Item(
          name: "Nome do produto em ordem crescente",
          selected: false,
          sort: () => buyRequestProvider.orderCartUpByName(),
        ),
        _Item(
          name: "Nome do produto em ordem decrescente",
          selected: false,
          sort: () => buyRequestProvider.orderCartDownByName(),
        ),
        _Item(
          name: "Custo total em ordem crescente",
          selected: false,
          sort: () => buyRequestProvider.orderCartUpByTotalCost(),
        ),
        _Item(
          name: "Custo total em ordem decrescente",
          selected: false,
          sort: () => buyRequestProvider.orderCartDownByTotalCost(),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context);

    var radioList = radios(buyRequestProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                      _expanded ? "Minimizar ordenação" : "Ordenar produtos"),
                ),
                const SizedBox(width: 10),
                Icon(
                  _expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                )
              ],
            ),
          ),
          if (_expanded)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(color: Colors.black26),
            ),
          Visibility(
            visible: _expanded,
            child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: radioList.length,
                itemBuilder: (context, index) {
                  return RadioListTile(
                    dense: true,
                    selected: radioList[index].selected,
                    groupValue: _groupValue,
                    subtitle: Text(radioList[index].name),
                    value: index,
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                    onChanged: (int? value) {
                      setState(() {
                        radioList[index].selected = !radioList[index].selected;
                        _groupValue = value;
                        radioList[index].sort();
                      });
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class _Item {
  final String name;
  bool selected;

  final Function sort;

  _Item({required this.name, required this.selected, required this.sort});
}
