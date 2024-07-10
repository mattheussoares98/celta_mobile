import 'package:celta_inventario/pages/adjust_sale_price/adjust_sale_price.dart';
import 'package:celta_inventario/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/global_widgets/global_widgets.dart';
import '../../../models/enterprise/enterprise_model.dart';

class RetailPricePage extends StatefulWidget {
  const RetailPricePage({super.key});

  @override
  State<RetailPricePage> createState() => _RetailPricePageState();
}

class _RetailPricePageState extends State<RetailPricePage> {
  final searchValueController = TextEditingController();
  final searchFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    searchFocusNode.dispose();
    searchValueController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AdjustSalePriceProvider adjustSalePriceProvider = Provider.of(context);
    ConfigurationsProvider configurationsProvider = Provider.of(context);
    EnterpriseModel enterprise =
        ModalRoute.of(context)!.settings.arguments as EnterpriseModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Varejo"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SearchWidget(
            focusNodeConsultProduct: searchFocusNode,
            showOnlyConfigurationOfSearch: true,
            isLoading: false,
            consultProductController: searchValueController,
            onPressSearch: () async {
              await adjustSalePriceProvider.getProducts(
                enterpriseCode: enterprise.codigoInternoEmpresa,
                searchValue: searchValueController.text,
                configurationsProvider: configurationsProvider,
              );
            },
          ),
          if (adjustSalePriceProvider.errorMessage != "" &&
              adjustSalePriceProvider.products.length == 0)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ErrorMessage(
                    errorMessage: adjustSalePriceProvider.errorMessage),
              ),
            ),
          if (!adjustSalePriceProvider.isLoading &&
              adjustSalePriceProvider.products.isNotEmpty)
            const ProductsItems(),
          // if (MediaQuery.of(context).viewInsets.bottom == 0 &&
          //     priceConferenceProvider.productsCount > 1)
          //   //só mostra a opção de organizar se houver mais de um produto e se o teclado estiver fechado
          //   PriceConferenceOrderProductsButtons(
          //       priceConferenceProvider: priceConferenceProvider)
        ],
      ),
    );
  }
}
