import 'package:celta_inventario/Components/Buttons/receipt_conference_consult_product_without_ean_button.dart';
import 'package:celta_inventario/Components/search_product_with_ean_plu_or_name_widget.dart';
import 'package:celta_inventario/Components/Procedures_items_widgets/receipt_conference_products_items.dart';
import 'package:celta_inventario/providers/receipt_conference_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/consulting_widget.dart';

class ConferencePage extends StatefulWidget {
  const ConferencePage({Key? key}) : super(key: key);

  @override
  State<ConferencePage> createState() => _ConferencePageState();
}

class _ConferencePageState extends State<ConferencePage> {
  @override
  void initState() {
    super.initState();
  }

  bool isLoaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isLoaded) {
      Provider.of<ReceiptConferenceProvider>(context, listen: false)
          .clearProducts();
    }
    isLoaded = true;
  }

  TextEditingController _consultProductController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _consultProductController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ReceiptConferenceProvider receiptConferenceProvider =
        Provider.of(context, listen: true);
    Map map = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text(
            '[${map["numeroProcRecebDoc"]}] ${map["emitterName"]}',
            style: const TextStyle(
              fontSize: 50,
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SearchProductWithEanPluOrNameWidget(
            focusNodeConsultProduct:
                receiptConferenceProvider.consultProductFocusNode,
            isLoading: receiptConferenceProvider.consultingProducts ||
                receiptConferenceProvider.isUpdatingQuantity,
            onPressSearch: () async {
              await receiptConferenceProvider.getProductByPluEanOrName(
                docCode: map["grDocCode"],
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
          if (receiptConferenceProvider.consultingProducts)
            Expanded(
              child: ConsultingWidget.consultingWidget(
                  title: 'Consultando produtos'),
            ),
          if (!receiptConferenceProvider.consultingProducts)
            ReceiptConferenceProductsItems(
              docCode: map["grDocCode"],
              receiptConferenceProvider: receiptConferenceProvider,
            ),
          if (MediaQuery.of(context).viewInsets.bottom == 0)
            ConferenceConsultProductWithoutEanButton(
              docCode: map["grDocCode"],
              receiptConferenceProvider: receiptConferenceProvider,
            ),
        ],
      ),
    );
  }
}
