import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
import '../../components/receipt/receipt.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';

class ReceiptConferencePage extends StatefulWidget {
  const ReceiptConferencePage({Key? key}) : super(key: key);

  @override
  State<ReceiptConferencePage> createState() => _ReceiptConferencePageState();
}

class _ReceiptConferencePageState extends State<ReceiptConferencePage> {
  TextEditingController _consultProductController = TextEditingController();
  TextEditingController _consultedProductController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _consultProductController.dispose();
    _consultedProductController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    ReceiptProvider receiptProvider = Provider.of(context, listen: true);
    ConfigurationsProvider configurationsProvider =
        Provider.of(context, listen: true);
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return Stack(
      children: [
        PopScope(
          canPop: !receiptProvider.isLoadingUpdateQuantity &&
              !receiptProvider.isLoadingProducts,
          onPopInvoked: (value) {
            if (value == true) {
              receiptProvider.clearProducts();
            }
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
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SearchWidget(
                  focusNodeConsultProduct:
                      receiptProvider.consultProductFocusNode,
                  isLoading: receiptProvider.isLoadingProducts ||
                      receiptProvider.isLoadingUpdateQuantity,
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
                if (MediaQuery.of(context).viewInsets.bottom == 0)
                  ConferenceConsultProductWithoutEanButton(
                    docCode: arguments["grDocCode"],
                  ),
              ],
            ),
          ),
        ),
        loadingWidget(
          message: 'Consultando produtos',
          isLoading: receiptProvider.isLoadingProducts,
        ),
        loadingWidget(
          message: 'Atualizando quantidade',
          isLoading: receiptProvider.isLoadingUpdateQuantity,
        ),
      ],
    );
  }
}
