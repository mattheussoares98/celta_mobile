import 'package:celta_inventario/components/Buy_request/buy_request_buyers_dropdown.dart';
import 'package:celta_inventario/components/Buy_request/buy_request_products_items.dart';
import 'package:celta_inventario/components/Buy_request/buy_request_requests_type_dropdown.dart';
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
  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuyRequestBuyersDropwodn(
              buyersKey: buyersKey,
              enabledChangeBuyer: false,
              showRefreshIcon: false,
            ),
            const SizedBox(height: 20),
            BuyRequestRequestsTypeDropdown(
              requestsKey: requestsKey,
              enabledChangeBuyer: false,
              showRefreshIcon: false,
            ),
            const SizedBox(height: 20),
            const Text(
              "Fornecedores",
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (buyRequestProvider.selectedBuyer == null)
              Text(
                buyRequestProvider.selectedRequestModel?.Name ??
                    "Não selecionado ainda",
              ),
            if (buyRequestProvider.selectedBuyer != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TitleAndSubtitle.titleAndSubtitle(
                        title: "Código",
                        value: buyRequestProvider.selectedSupplier!.Code
                            .toString(),
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
                        value:
                            buyRequestProvider.selectedSupplier!.CnpjCpfNumber,
                      ),
                      TitleAndSubtitle.titleAndSubtitle(
                        title: "Tipo de comércio",
                        value:
                            buyRequestProvider.selectedSupplier!.SupplierType,
                      ),
                      if (buyRequestProvider.selectedSupplier!.Addresses !=
                          null)
                        Text(buyRequestProvider.selectedSupplier!.Addresses
                            .toString()),
                      if (buyRequestProvider.selectedSupplier!.Telephones !=
                          null)
                        Text(buyRequestProvider.selectedSupplier!.Telephones
                            .toString()),
                      if (buyRequestProvider.selectedSupplier!.Emails != null)
                        Text(buyRequestProvider.selectedSupplier!.Emails
                            .toString()),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              "Empresas",
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Produtos",
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
            const BuyRequestProductsItems(
              showOnlyCartProducts: true,
            ),
          ],
        ),
      ),
    );
  }
}
