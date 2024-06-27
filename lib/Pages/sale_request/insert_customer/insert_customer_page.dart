import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/global_widgets/global_widgets.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';
import 'insert_customer.dart';

class InsertCustomerPage extends StatefulWidget {
  final int enterpriseCode;
  const InsertCustomerPage({
    required this.enterpriseCode,
    Key? key,
  }) : super(key: key);

  @override
  State<InsertCustomerPage> createState() =>
      _InsertCustomerPageState();
}

class _InsertCustomerPageState extends State<InsertCustomerPage> {
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
    ConfigurationsProvider configurationsProvider =
        Provider.of(context, listen: false);

    return Scaffold(
      body: Column(
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
                configurationsProvider: configurationsProvider,
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
            CustomersItems(enterpriseCode: widget.enterpriseCode),
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
                    configurationsProvider: configurationsProvider,
                  );
                },
              ),
            ),
          if (saleRequestProvider.errorMessageCustomer != "" &&
              saleRequestProvider
                      .customersCount(widget.enterpriseCode.toString()) >
                  0)
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: ErrorMessage(
                  errorMessage: saleRequestProvider.errorMessageCustomer,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Cadastrar cliente",
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.person_add, color: Colors.white),
        onPressed: () {
          Navigator.of(context).pushNamed(
            APPROUTES.CUSTOMER_REGISTER,
          );
        },
      ),
    );
  }
}
