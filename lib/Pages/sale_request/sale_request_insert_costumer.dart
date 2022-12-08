import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Components/Global_widgets/search_widget.dart';
import '../../providers/sale_request_provider.dart';

class SaleRequestInsertCostumer extends StatefulWidget {
  const SaleRequestInsertCostumer({Key? key}) : super(key: key);

  @override
  State<SaleRequestInsertCostumer> createState() =>
      _SaleRequestInsertCostumerState();
}

class _SaleRequestInsertCostumerState extends State<SaleRequestInsertCostumer> {
  final TextEditingController searchCostumerController =
      TextEditingController();
  final FocusNode searchCostumerFocusNode = FocusNode();
  bool _useDefaultCostumer = false;
  String _selectedCostumer = "";

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider =
        Provider.of(context, listen: true);

    return Column(
      children: [
        SearchWidget(
          consultProductController: searchCostumerController,
          isLoading: saleRequestProvider.isLoadingCostumer,
          autofocus: false,
          onPressSearch: () async {
            await saleRequestProvider.getCostumers(
              context: context,
              searchValueControllerText: searchCostumerController.text,
            );
          },
          focusNodeConsultProduct: searchCostumerFocusNode,
          hintText: "Código, nome ou CPF",
          labelText: "Consultar cliente",
          useCamera: false,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Card(
            elevation: 5,
            shape: Border.all(
              color: const Color.fromARGB(255, 214, 214, 214),
            ),
            child: CheckboxListTile(
                activeColor: Colors.black,
                title: const Text("Cliente consumidor"),
                value: _useDefaultCostumer,
                onChanged: (bool? value) {
                  setState(() {
                    _useDefaultCostumer = value!;
                  });
                  if (_useDefaultCostumer) {
                    _selectedCostumer = "1-Consumidor";
                  }
                }),
          ),
        ),
      ],
    );
  }
}
