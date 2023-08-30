import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Components/Global_widgets/search_widget.dart';
import '../../Components/Global_widgets/try_again.dart';
import '../../components/Sale_request/sale_request_customer_items.dart';
import '../../providers/sale_request_provider.dart';
import '../../Components/Global_widgets/consulting_widget.dart';
import '../../Components/Global_widgets/error_message.dart';

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
            child: TryAgainWidget.tryAgain(
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
        if (saleRequestProvider.isLoadingCustomer)
          Expanded(
            child: ConsultingWidget.consultingWidget(
                title: "Consultando clientes"),
          ),
      ],
    );
  }
}
