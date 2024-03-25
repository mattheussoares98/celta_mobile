import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
import '../../components/sale_request/sale_request.dart';
import '../../providers/providers.dart';

class SaleRequestInsertCustomer extends StatefulWidget {
  final int enterpriseCode;
  const SaleRequestInsertCustomer({
    required this.enterpriseCode,
    Key? key,
  }) : super(key: key);

  @override
  State<SaleRequestInsertCustomer> createState() =>
      _SaleRequestInsertCustomerState();
}

class _SaleRequestInsertCustomerState extends State<SaleRequestInsertCustomer> {
  final TextEditingController searchCustomerController =
      TextEditingController();
  final FocusNode searchCustomerFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    searchCustomerController.dispose();
    searchCustomerFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider =
        Provider.of(context, listen: true);

    return Column(
      children: [
        SearchWidget(
          consultProductController: searchCustomerController,
          isLoading: saleRequestProvider.isLoadingCustomer,
          autofocus: false,
          onPressSearch: () async {
            await saleRequestProvider.getCustomers(
              context: context,
              controllerText: searchCustomerController.text,
              enterpriseCode: widget.enterpriseCode.toString(),
            );

            if (saleRequestProvider
                    .customersCount(widget.enterpriseCode.toString()) >
                0) {
              searchCustomerController.clear();
            }
          },
          focusNodeConsultProduct: searchCustomerFocusNode,
          hintText: "Código, nome, CPF ou CNPJ",
          labelText: "Consultar cliente",
          useCamera: false,
        ),
        if (saleRequestProvider
                .customersCount(widget.enterpriseCode.toString()) >
            0)
          SaleRequestCustomersItems(enterpriseCode: widget.enterpriseCode),
        if (saleRequestProvider.errorMessageCustomer != "" &&
            saleRequestProvider
                    .customersCount(widget.enterpriseCode.toString()) ==
                0)
          Expanded(
            child: searchAgain(
              errorMessage:
                  'Ocorreu um erro para consultar o cliente "consumidor"',
              request: () async {
                await saleRequestProvider.getCustomers(
                  context: context,
                  controllerText: "-1",
                  enterpriseCode: widget.enterpriseCode.toString(),
                );
              },
            ),
          ),
        if (saleRequestProvider.errorMessageCustomer != "" &&
            saleRequestProvider
                    .customersCount(widget.enterpriseCode.toString()) >
                0)
          ErrorMessage(
            errorMessage: saleRequestProvider.errorMessageCustomer,
          ),
      ],
    );
  }
}
