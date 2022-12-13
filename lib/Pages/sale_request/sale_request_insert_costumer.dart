import 'package:celta_inventario/Components/Sale_request/sale_request_costumer_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Components/Global_widgets/search_widget.dart';
import '../../providers/sale_request_provider.dart';
import '../../utils/consulting_widget.dart';
import '../../utils/error_message.dart';

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
        if (saleRequestProvider.costumersCount > 0)
          const SaleRequestCostumersItems(),
        if (saleRequestProvider.errorMessageCostumer != "")
          ErrorMessage(
            errorMessage: saleRequestProvider.errorMessageCostumer,
          ),
        if (saleRequestProvider.isLoadingCostumer)
          Expanded(
            child: ConsultingWidget.consultingWidget(
                title: "Consultando clientes"),
          ),
      ],
    );
  }
}
