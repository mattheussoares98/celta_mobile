import 'package:celta_inventario/components/Buy_request/buy_request_enterprises.dart';
import 'package:celta_inventario/components/Buy_request/buy_request_observations.dart';
import 'package:celta_inventario/components/Buy_request/buy_request_title_component.dart';
import 'package:celta_inventario/components/Buy_request/details/last_saved_requests.dart';
import 'package:celta_inventario/components/Buy_request/identification/buy_request_buyers_dropdown.dart';
import 'package:celta_inventario/components/Buy_request/identification/buy_request_requests_type_dropdown.dart';
import 'package:celta_inventario/components/Buy_request/products/buy_request_order_products.dart';
import 'package:celta_inventario/components/Buy_request/products/buy_request_products_items.dart';
import 'package:celta_inventario/components/Buy_request/buy_request_save.dart';
import 'package:celta_inventario/components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/providers/buy_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context);

    _focusNode.addListener(() {
      setState(() {});
    });

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
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
        if (!_focusNode.hasFocus) const BuyRequestSave(),
      ],
    );
  }
}
