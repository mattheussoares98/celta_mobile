import 'package:celta_inventario/components/Transfer_between_stocks/transfer_between_stocks_justifications_stocks_dropdown.dart';
import 'package:celta_inventario/Components/Global_widgets/error_message.dart';
import 'package:celta_inventario/components/Transfer_between_stocks/transfer_between_stocks_products_items.dart';
import 'package:celta_inventario/providers/transfer_between_stocks_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Components/Global_widgets/search_widget.dart';
import '../Components/Global_widgets/consulting_widget.dart';

class TransferBetweenStockPage extends StatefulWidget {
  const TransferBetweenStockPage({Key? key}) : super(key: key);

  @override
  State<TransferBetweenStockPage> createState() =>
      _TransferBetweenStockPageState();
}

class _TransferBetweenStockPageState extends State<TransferBetweenStockPage> {
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

  bool _isLegacyCodeSearch = false;

  @override
  Widget build(BuildContext context) {
    TransferBetweenStocksProvider transferBetweenStocksProvider =
        Provider.of(context, listen: true);
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return WillPopScope(
      onWillPop: () async {
        transferBetweenStocksProvider
            .clearProductsJustificationsStockTypesAndJsonAdjustStock();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const FittedBox(
            child: Text(
              'TRANSFERÊNCIA ENTRE ESTOQUES',
            ),
          ),
          leading: IconButton(
            onPressed: () {
              transferBetweenStocksProvider
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
                  hasLegacyCodeSearch: true,
                  changeLegacyIsSelectedFunction: () {
                    setState(() {
                      _isLegacyCodeSearch = !_isLegacyCodeSearch;
                    });
                  },
                  useLegacyCode: _isLegacyCodeSearch,
                  focusNodeConsultProduct:
                      transferBetweenStocksProvider.consultProductFocusNode,
                  isLoading: transferBetweenStocksProvider.isLoadingProducts ||
                      transferBetweenStocksProvider.isLoadingAdjustStock,
                  onPressSearch: () async {
                    await transferBetweenStocksProvider.getProducts(
                      enterpriseCode: arguments["CodigoInterno_Empresa"],
                      controllerText: _consultProductController.text,
                      context: context,
                      isLegacyCodeSearch: _isLegacyCodeSearch,
                    );

                    //não estava funcionando passar o productsCount como parâmetro
                    //para o "SearchProductWithEanPluOrNameWidget" para apagar o
                    //textEditingController após a consulta dos produtos se encontrar
                    //algum produto
                    if (transferBetweenStocksProvider.productsCount > 0) {
                      //se for maior que 0 significa que deu certo a consulta e
                      //por isso pode apagar o que foi escrito no campo de
                      //consulta
                      _consultProductController.clear();
                    }
                  },
                  consultProductController: _consultProductController,
                ),
                TransferBetweenStocksJustificationsAndStocksDropwdownWidget(
                  dropDownFormKey: _dropDownFormKey,
                ),
              ],
            ),
            if (transferBetweenStocksProvider.isLoadingProducts)
              Expanded(
                child: ConsultingWidget.consultingWidget(
                  title: 'Consultando produtos',
                ),
              ),
            if (transferBetweenStocksProvider.errorMessageGetProducts != "")
              ErrorMessage(
                errorMessage:
                    transferBetweenStocksProvider.errorMessageGetProducts,
              ),
            if (!transferBetweenStocksProvider.isLoadingProducts)
              TransferBetweenStocksProductsItems(
                internalEnterpriseCode: arguments["CodigoInterno_Empresa"],
                consultedProductController: _consultedProductController,
                dropDownFormKey: _dropDownFormKey,
                insertQuantityFormKey: _insertQuantityFormKey,
              ),
          ],
        ),
      ),
    );
  }
}
