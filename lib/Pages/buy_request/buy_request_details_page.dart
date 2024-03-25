import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/buy_request/buy_request.dart';
import '../../components/global_widgets/global_widgets.dart';
import '../../providers/providers.dart';

class BuyRequestDetailsPage extends StatefulWidget {
  const BuyRequestDetailsPage({Key? key}) : super(key: key);

  @override
  State<BuyRequestDetailsPage> createState() => _BuyRequestDetailsPageState();
}

class _BuyRequestDetailsPageState extends State<BuyRequestDetailsPage> {
  GlobalKey<FormFieldState<dynamic>> buyersKey = GlobalKey();
  GlobalKey<FormFieldState<dynamic>> requestsKey = GlobalKey();

  Widget selectedSupplierWidget(BuyRequestProvider buyRequestProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: buyRequestTitleComponent(
            title: buyRequestProvider.selectedSupplier == null
                ? "Selecione o fornecedor"
                : "Fornecedor",
            context: context,
            isError: buyRequestProvider.selectedSupplier == null,
          ),
        ),
        if (buyRequestProvider.selectedSupplier != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Código",
                    value: buyRequestProvider.selectedSupplier!.Code.toString(),
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Nome",
                    value: buyRequestProvider.selectedSupplier!.Name,
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Nome fantasia",
                    value: buyRequestProvider.selectedSupplier!.FantasizesName,
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "CPF/CNPJ",
                    value: buyRequestProvider.selectedSupplier!.CnpjCpfNumber,
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Tipo de comércio",
                    value: buyRequestProvider.selectedSupplier!.SupplierType,
                  ),
                  if (buyRequestProvider.selectedSupplier!.Addresses != null)
                    Text(buyRequestProvider.selectedSupplier!.Addresses
                        .toString()),
                  if (buyRequestProvider.selectedSupplier!.Telephones != null)
                    Text(buyRequestProvider.selectedSupplier!.Telephones
                        .toString()),
                  if (buyRequestProvider.selectedSupplier!.Emails != null)
                    Text(
                        buyRequestProvider.selectedSupplier!.Emails.toString()),
                ],
              ),
            ),
          ),
      ],
    );
  }

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    BuyRequestProvider buyRequestProvider = Provider.of(context, listen: false);
    buyRequestProvider.indexOfSelectedProduct = -1;
  }

  @override
  void dispose() {
    super.dispose();

    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context);

    _focusNode.addListener(() {
      setState(() {});
    });

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            primary: false,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const LastSavedRequests(),
                  BuyRequestObservations(focusNode: _focusNode),
                  buyRequestTitleComponent(
                    title: buyRequestProvider.selectedBuyer == null
                        ? "Selecione o comprador"
                        : "Comprador",
                    context: context,
                    isError: buyRequestProvider.selectedBuyer == null,
                  ),
                  BuyRequestBuyersDropwodn(
                    buyersKey: buyersKey,
                    enabledChangeBuyer: false,
                    showRefreshIcon: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: buyRequestTitleComponent(
                      errorTitle: "Selecione o modelo de pedido",
                      title: "Modelo de pedido",
                      context: context,
                      isError: buyRequestProvider.selectedRequestModel == null,
                    ),
                  ),
                  BuyRequestRequestsTypeDropdown(
                    requestsKey: requestsKey,
                    enabledChangeRequestsType: false,
                    showRefreshIcon: false,
                  ),
                  selectedSupplierWidget(buyRequestProvider),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: buyRequestTitleComponent(
                      title: "Empresas",
                      errorTitle: "Selecione a(s) empresa(s)",
                      context: context,
                      isError: !buyRequestProvider.hasSelectedEnterprise,
                    ),
                  ),
                  const BuyRequestEnterprises(
                    showOnlySelectedsEnterprises: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: buyRequestTitleComponent(
                      errorTitle: "Insira produtos",
                      title: "Produtos",
                      context: context,
                      isError: buyRequestProvider.productsInCartCount == 0,
                    ),
                  ),
                  if (buyRequestProvider.productsInCartCount > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (buyRequestProvider.productsInCartCount > 2)
                            const BuyRequestOrderProducts(),
                          const BuyRequestProductsItems(
                            showOnlyCartProducts: true,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (MediaQuery.of(context).viewInsets.bottom == 0)
          const BuyRequestSave(),
      ],
    );
  }
}
