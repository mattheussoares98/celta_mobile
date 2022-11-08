import 'package:celta_inventario/Components/Procedures_items_widgets/adjust_stock_products_items.dart';
import 'package:celta_inventario/Components/Adjust_stock_components/adjust_stock_justifications_stocks_dropdown.dart';
import 'package:celta_inventario/providers/adjust_stock_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Components/search_product_with_ean_plu_or_name_widget.dart';
import '../utils/consulting_widget.dart';

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

  bool _isLoaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isLoaded) {
      AdjustStockProvider adjustStockProvider =
          Provider.of(context, listen: false);
      adjustStockProvider.getStockTypeAndJustifications(context);
      _isLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    AdjustStockProvider adjustStockProvider =
        Provider.of(context, listen: true);
    int codigoInternoEmpresa =
        ModalRoute.of(context)!.settings.arguments as int;

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
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SearchProductWithEanPluOrNameWidget(
              focusNodeConsultProduct:
                  adjustStockProvider.consultProductFocusNode,
              isLoading: adjustStockProvider.isLoadingProducts ||
                  adjustStockProvider.isLoadingAdjustStock,
              onPressSearch: () async {
                await adjustStockProvider.getProductByPluEanOrName(
                  enterpriseCode: codigoInternoEmpresa,
                  controllerText: _consultProductController.text,
                  context: context,
                );

                //não estava funcionando passar o productsCount como parâmetro
                //para o "SearchProductWithEanPluOrNameWidget" para apagar o
                //textEditingController após a consulta dos produtos se encontrar
                //algum produto
                if (adjustStockProvider.productsCount > 0) {
                  //se for maior que 0 significa que deu certo a consulta e
                  //por isso pode apagar o que foi escrito no campo de
                  //consulta
                  _consultProductController.clear();
                }
              },
              consultProductController: _consultProductController,
            ),
            AdjustStockJustificationsStockDropwdownWidget(
              adjustStockProvider: adjustStockProvider,
              dropDownFormKey: _dropDownFormKey,
            ),
            if (adjustStockProvider.isLoadingProducts)
              Expanded(
                child: ConsultingWidget.consultingWidget(
                  title: 'Consultando produtos',
                ),
              ),
            if (!adjustStockProvider.isLoadingProducts)
              AdjustStockProductsItems(
                internalEnterpriseCode: codigoInternoEmpresa,
                adjustStockProvider: adjustStockProvider,
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
