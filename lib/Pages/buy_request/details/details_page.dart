import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/buyers/buyers.dart';
import '../../../providers/providers.dart';
import '../components/components.dart';
import '../enterprises/enterprises.dart';
import '../products/products.dart';
import 'details.dart';
import '../identification/identification.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  GlobalKey<FormFieldState<dynamic>> buyersKey = GlobalKey();
  GlobalKey<FormFieldState<dynamic>> requestsKey = GlobalKey();

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
                  Observations(focusNode: _focusNode),
                  Text(
                    buyRequestProvider.selectedBuyer == null
                        ? "Selecione o comprador"
                        : "Comprador",
                    style: TextStyle(
                      color: buyRequestProvider.selectedBuyer == null
                          ? Colors.red
                          : Theme.of(context).colorScheme.primary,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  BuyersDropDown(
                    enabled: false,
                    value: buyRequestProvider.selectedBuyer,
                    dropdownKey: buyersKey,
                    disabledHintText: "Comprador",
                    buyers: buyRequestProvider.buyers,
                    onChanged: (value) {
                      buyRequestProvider.selectedBuyer = value;
                    },
                    reloadBuyers: () async {
                      await buyRequestProvider.getBuyers(
                        isSearchingAgain: true,
                        context: context,
                      );
                    },
                    showRefreshIcon: false,
                    onTap: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: TitleComponent(
                      errorTitle: "Selecione o modelo de pedido",
                      title: "Modelo de pedido",
                      isError: buyRequestProvider.selectedRequestModel == null,
                    ),
                  ),
                  RequestsTypeDropdown(
                    requestsKey: requestsKey,
                    enabledChangeRequestsType: false,
                    showRefreshIcon: false,
                  ),
                  const SelectedSupplier(),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: TitleComponent(
                      title: "Empresas",
                      errorTitle: "Selecione a(s) empresa(s)",
                      isError: !buyRequestProvider.hasSelectedEnterprise,
                    ),
                  ),
                  const EnterpriseItems(checkBoxEnabled: false),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: TitleComponent(
                      errorTitle: "Insira produtos",
                      title: "Produtos",
                      isError: buyRequestProvider.productsInCartCount == 0,
                    ),
                  ),
                  if (buyRequestProvider.productsInCartCount > 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (buyRequestProvider.productsInCartCount > 2)
                          const OrderProducts(),
                        const ProductsItems(
                          showOnlyCartProducts: true,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
        if (MediaQuery.of(context).viewInsets.bottom == 0)
          const SaveBuyRequestButton(),
      ],
    );
  }
}
