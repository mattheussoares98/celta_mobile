import 'package:celta_inventario/components/Global_widgets/search_widget.dart';
import 'package:celta_inventario/providers/buy_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuyRequestSuplliers extends StatefulWidget {
  const BuyRequestSuplliers({Key? key}) : super(key: key);

  @override
  State<BuyRequestSuplliers> createState() => _BuyRequestSuplliersState();
}

class _BuyRequestSuplliersState extends State<BuyRequestSuplliers> {
  TextEditingController consultProductController = TextEditingController();
  FocusNode focusNodeConsultProduct = FocusNode();

  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context);
    return Column(
      children: [
        SearchWidget(
          showConfigurationsIcon: false,
          hintText: "Fornecedor",
          labelText: "Consultar fornecedor",
          useCamera: false,
          autofocus: false,
          consultProductController: consultProductController,
          isLoading: buyRequestProvider.isLoadingSupplier,
          onPressSearch: () async {
            buyRequestProvider.getSuppliers(context: context);
          },
          focusNodeConsultProduct: focusNodeConsultProduct,
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: buyRequestProvider.suppliersCount,
          itemBuilder: (context, index) => Card(
            child: Text("buyRequestProvider.suppliers[index]."),
          ),
        ),
      ],
    );
  }
}
