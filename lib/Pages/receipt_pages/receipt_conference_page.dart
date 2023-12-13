import 'package:celta_inventario/Components/Receipt/receipt_conference_consult_product_without_ean_button.dart';
import 'package:celta_inventario/Components/Global_widgets/search_widget.dart';
import 'package:celta_inventario/Components/Receipt/receipt_conference_products_items.dart';
import 'package:celta_inventario/Components/Global_widgets/error_message.dart';
import 'package:celta_inventario/providers/configurations_provider.dart';
import 'package:celta_inventario/providers/receipt_provider.dart';
import 'package:celta_inventario/utils/scan_bar_code.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/Global_widgets/searching_widget.dart';

class ReceiptConferencePage extends StatefulWidget {
  const ReceiptConferencePage({Key? key}) : super(key: key);

  @override
  State<ReceiptConferencePage> createState() => _ReceiptConferencePageState();
}

class _ReceiptConferencePageState extends State<ReceiptConferencePage> {
  TextEditingController _consultProductController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _consultProductController.dispose();
  }

  TextEditingController _consultedProductController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ReceiptProvider receiptProvider = Provider.of(context, listen: true);
    ConfigurationsProvider configurationsProvider =
        Provider.of(context, listen: true);
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return PopScope(
      canPop: true,
      onPopInvoked: (_) async {
        Future.delayed(const Duration(milliseconds: 300), () {
          receiptProvider.clearProducts();
        });
      },
      child: Scaffold(
        resizeToAvoidBottomInset: kIsWeb ? false : true,
        appBar: AppBar(
          title: FittedBox(
            child: Text(
              '[${arguments["numeroProcRecebDoc"]}] ${arguments["emitterName"]}',
              style: const TextStyle(
                fontSize: 50,
              ),
            ),
          ),
          leading: IconButton(
            onPressed: () {
              receiptProvider.clearProducts();
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_outlined),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SearchWidget(
              focusNodeConsultProduct: receiptProvider.consultProductFocusNode,
              isLoading: receiptProvider.consultingProducts ||
                  receiptProvider.isUpdatingQuantity,
              onPressSearch: () async {
                await receiptProvider.getProducts(
                  configurationsProvider: configurationsProvider,
                  docCode: arguments["grDocCode"],
                  controllerText: _consultProductController.text,
                  context: context,
                  isSearchAllCountedProducts: false,
                );

                //não estava funcionando passar o productsCount como parâmetro
                //para o "SearchProductWithEanPluOrNameWidget" para apagar o
                //textEditingController após a consulta dos produtos se encontrar
                //algum produto
                if (receiptProvider.productsCount > 0) {
                  //se for maior que 0 significa que deu certo a consulta e
                  //por isso pode apagar o que foi escrito no campo de
                  //consulta
                  _consultProductController.clear();
                }
              },
              consultProductController: _consultProductController,
            ),
            if (receiptProvider.errorMessageGetProducts != "")
              ErrorMessage(
                errorMessage: receiptProvider.errorMessageGetProducts,
              ),
            if (receiptProvider.consultingProducts)
              Expanded(
                child: searchingWidget(title: 'Consultando produtos'),
              ),
            if (!receiptProvider.consultingProducts)
              ReceiptConferenceProductsItems(
                getProductsWithCamera: () async {
                  FocusScope.of(context).unfocus();
                  _consultProductController.clear();

                  _consultProductController.text =
                      await ScanBarCode.scanBarcode(context);

                  if (_consultProductController.text != "") {
                    await receiptProvider.getProducts(
                      configurationsProvider: configurationsProvider,
                      docCode: arguments["grDocCode"],
                      controllerText: _consultProductController.text,
                      context: context,
                      isSearchAllCountedProducts: false,
                    );
                  }

                  if (receiptProvider.productsCount > 0) {
                    _consultProductController.clear();
                  }
                },
                docCode: arguments["grDocCode"],
                consultedProductController: _consultedProductController,
                consultProductController: _consultProductController,
              ),
            if (MediaQuery.of(context).viewInsets.bottom == 0 ||
                receiptProvider.productsCount == 0)
              ConferenceConsultProductWithoutEanButton(
                docCode: arguments["grDocCode"],
              ),
          ],
        ),
      ),
    );
  }
}
