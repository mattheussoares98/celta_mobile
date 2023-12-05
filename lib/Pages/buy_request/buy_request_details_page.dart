import 'package:celta_inventario/components/Buy_request/buy_request_enterprises.dart';
import 'package:celta_inventario/components/Buy_request/buy_request_observations.dart';
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
    if (buyRequestProvider.selectedSupplier != null)
      return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Fornecedor",
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "Código",
                      value:
                          buyRequestProvider.selectedSupplier!.Code.toString(),
                    ),
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "Nome",
                      value: buyRequestProvider.selectedSupplier!.Name,
                    ),
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "Nome fantasia",
                      value:
                          buyRequestProvider.selectedSupplier!.FantasizesName,
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
                      Text(buyRequestProvider.selectedSupplier!.Emails
                          .toString()),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    else {
      return const Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Text(
          "Não há fornecedor selecionado",
          style: TextStyle(
            color: Color.fromARGB(255, 183, 28, 28),
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }
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
                  BuyRequestBuyersDropwodn(
                    buyersKey: buyersKey,
                    enabledChangeBuyer: false,
                    showRefreshIcon: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: BuyRequestRequestsTypeDropdown(
                      requestsKey: requestsKey,
                      enabledChangeRequestsType: false,
                      showRefreshIcon: false,
                    ),
                  ),
                  selectedSupplierWidget(buyRequestProvider),
                  if (buyRequestProvider.hasSelectedEnterprise)
                    const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: BuyRequestEnterprises(
                        showOnlySelectedsEnterprises: true,
                      ),
                    ),
                  if (!buyRequestProvider.hasSelectedEnterprise)
                    const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text(
                        "Não há empresa selecionada",
                        style: TextStyle(
                          color: Color.fromARGB(255, 183, 28, 28),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  if (buyRequestProvider.productsInCartCount == 0)
                    const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text(
                        "Não há produtos informados",
                        style: TextStyle(
                          color: Color.fromARGB(255, 183, 28, 28),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  if (buyRequestProvider.productsInCartCount > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Produtos",
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
