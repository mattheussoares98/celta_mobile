import 'package:celta_inventario/Components/Adjust_stock/adjust_stock_products_items.dart';
import 'package:celta_inventario/components/Adjust_stock/adjust_stock_justifications_stocks_dropdown.dart';
import 'package:celta_inventario/providers/adjust_stock_provider.dart';
import 'package:celta_inventario/Components/Global_widgets/error_message.dart';
import 'package:celta_inventario/providers/configurations_provider.dart';
import 'package:celta_inventario/utils/scan_bar_code.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Components/Global_widgets/search_widget.dart';
import '../Components/Global_widgets/consulting_widget.dart';

class AdjustStockPage extends StatefulWidget {
  const AdjustStockPage({Key? key}) : super(key: key);

  @override
  State<AdjustStockPage> createState() => _AdjustStockPageState();
}

class _AdjustStockPageState extends State<AdjustStockPage> {
  final TextEditingController _consultProductController =
      TextEditingController();
  final TextEditingController _consultedProductController =
      TextEditingController();

  var _insertQuantityFormKey = GlobalKey<FormState>();
  var _dropDownFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _consultProductController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AdjustStockProvider adjustStockProvider =
        Provider.of(context, listen: true);
    ConfigurationsProvider configurationsProvider =
        Provider.of(context, listen: true);
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return WillPopScope(
      onWillPop: () async {
        adjustStockProvider
            .clearProductsJustificationsStockTypesAndJsonAdjustStock();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'AJUSTE DE ESTOQUE  ',
          ),
          leading: IconButton(
            onPressed: () {
              adjustStockProvider
                  .clearProductsJustificationsStockTypesAndJsonAdjustStock();
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
            ),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                SearchWidget(
                  focusNodeConsultProduct:
                      adjustStockProvider.consultProductFocusNode,
                  isLoading: adjustStockProvider.isLoadingProducts ||
                      adjustStockProvider.isLoadingAdjustStock,
                  onPressSearch: () async {
                    await adjustStockProvider.getProducts(
                      enterpriseCode: arguments["CodigoInterno_Empresa"],
                      controllerText: _consultProductController.text,
                      context: context,
                      configurationsProvider: configurationsProvider,
                    );

                    if (adjustStockProvider.productsCount > 0) {
                      _consultProductController.clear();
                    }
                  },
                  consultProductController: _consultProductController,
                ),
                AdjustStockJustificationsStockDropwdownWidget(
                  dropDownFormKey: _dropDownFormKey,
                ),
              ],
            ),
            if (adjustStockProvider.isLoadingProducts)
              Expanded(
                child: ConsultingWidget.consultingWidget(
                  title: 'Consultando produtos',
                ),
              ),
            if (adjustStockProvider.errorMessageGetProducts != "")
              ErrorMessage(
                errorMessage: adjustStockProvider.errorMessageGetProducts,
              ),
            if (!adjustStockProvider.isLoadingProducts)
              AdjustStockProductsItems(
                  internalEnterpriseCode: arguments["CodigoInterno_Empresa"],
                  consultedProductController: _consultedProductController,
                  dropDownFormKey: _dropDownFormKey,
                  insertQuantityFormKey: _insertQuantityFormKey,
                  getProductWithCamera: () async {
                    FocusScope.of(context).unfocus();
                    _consultProductController.clear();

                    _consultProductController.text =
                        await ScanBarCode.scanBarcode();

                    if (_consultProductController.text == "") {
                      return;
                    }

                    await adjustStockProvider.getProducts(
                      enterpriseCode: arguments["CodigoInterno_Empresa"],
                      controllerText: _consultProductController.text,
                      context: context,
                      configurationsProvider: configurationsProvider,
                    );

                    if (adjustStockProvider.productsCount > 0) {
                      _consultProductController.clear();
                    }
                  }),
          ],
        ),
      ),
    );
  }
}
