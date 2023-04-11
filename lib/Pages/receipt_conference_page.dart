import 'package:celta_inventario/Components/Receipt/receipt_conference_consult_product_without_ean_button.dart';
import 'package:celta_inventario/Components/Global_widgets/search_widget.dart';
import 'package:celta_inventario/Components/Receipt/receipt_conference_products_items.dart';
import 'package:celta_inventario/providers/receipt_conference_provider.dart';
import 'package:celta_inventario/Components/Global_widgets/error_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Components/Global_widgets/consulting_widget.dart';

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
  bool _legacyIsSelected = false;

  @override
  Widget build(BuildContext context) {
    ReceiptConferenceProvider receiptConferenceProvider =
        Provider.of(context, listen: true);
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return WillPopScope(
      onWillPop: () async {
        Future.delayed(const Duration(milliseconds: 300), () {
          receiptConferenceProvider.clearProducts();
        });
        return true;
      },
      child: Scaffold(
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
              receiptConferenceProvider.clearProducts();
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
              legacyIsSelected: _legacyIsSelected,
              hasLegacyCodeSearch: true,
              changeLegacyIsSelectedFunction: () {
                setState(() {
                  _legacyIsSelected = !_legacyIsSelected;
                });
              },
              focusNodeConsultProduct:
                  receiptConferenceProvider.consultProductFocusNode,
              isLoading: receiptConferenceProvider.consultingProducts ||
                  receiptConferenceProvider.isUpdatingQuantity,
              onPressSearch: () async {
                await receiptConferenceProvider.getProduct(
                  isLegacyCodeSearch: _legacyIsSelected,
                  docCode: arguments["grDocCode"],
                  controllerText: _consultProductController.text,
                  context: context,
                );

                //não estava funcionando passar o productsCount como parâmetro
                //para o "SearchProductWithEanPluOrNameWidget" para apagar o
                //textEditingController após a consulta dos produtos se encontrar
                //algum produto
                if (receiptConferenceProvider.productsCount > 0) {
                  //se for maior que 0 significa que deu certo a consulta e
                  //por isso pode apagar o que foi escrito no campo de
                  //consulta
                  _consultProductController.clear();
                }
              },
              consultProductController: _consultProductController,
            ),
            if (receiptConferenceProvider.errorMessageGetProducts != "")
              ErrorMessage(
                errorMessage: receiptConferenceProvider.errorMessageGetProducts,
              ),
            if (receiptConferenceProvider.consultingProducts)
              Expanded(
                child: ConsultingWidget.consultingWidget(
                    title: 'Consultando produtos'),
              ),
            if (!receiptConferenceProvider.consultingProducts)
              ReceiptConferenceProductsItems(
                docCode: arguments["grDocCode"],
                consultedProductController: _consultedProductController,
                consultProductController: _consultProductController,
              ),
            if (MediaQuery.of(context).viewInsets.bottom == 0 ||
                receiptConferenceProvider.productsCount == 0)
              ConferenceConsultProductWithoutEanButton(
                docCode: arguments["grDocCode"],
              ),
          ],
        ),
      ),
    );
  }
}
