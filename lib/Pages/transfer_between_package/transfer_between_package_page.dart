import 'package:celta_inventario/components/Global_widgets/consulting_widget.dart';
import 'package:celta_inventario/components/Global_widgets/search_widget.dart';
import 'package:celta_inventario/components/Transfer_between_package/transfer_between_package_products_items.dart';
import 'package:celta_inventario/components/Transfer_between_package/transfer_between_stocks_justifications_stocks_dropdown.dart';
import 'package:celta_inventario/Components/Global_widgets/error_message.dart';
import 'package:celta_inventario/providers/configurations_provider.dart';
import 'package:celta_inventario/providers/transfer_between_package_provider_SemImplementacaoAinda.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransferBetweenPackagePage extends StatefulWidget {
  const TransferBetweenPackagePage({Key? key}) : super(key: key);

  @override
  State<TransferBetweenPackagePage> createState() =>
      _TransferBetweenPackagePageState();
}

class _TransferBetweenPackagePageState
    extends State<TransferBetweenPackagePage> {
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
    TransferBetweenPackageProvider transferBetweenPackageProvider =
        Provider.of(context, listen: true);
    ConfigurationsProvider configurationsProvider =
        Provider.of(context, listen: true);
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return WillPopScope(
      onWillPop: () async {
        transferBetweenPackageProvider
            .clearProductsJustificationsPackageAndJsonAdjustStock();
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
              transferBetweenPackageProvider
                  .clearProductsJustificationsPackageAndJsonAdjustStock();
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
                      transferBetweenPackageProvider.consultProductFocusNode,
                  isLoading: transferBetweenPackageProvider.isLoadingProducts ||
                      transferBetweenPackageProvider
                          .isLoadingConfirmTransferPackage,
                  onPressSearch: () async {
                    await transferBetweenPackageProvider.getProducts(
                      enterpriseCode: arguments["CodigoInterno_Empresa"],
                      controllerText: _consultProductController.text,
                      context: context,
                      configurationsProvider: configurationsProvider,
                    );

                    //não estava funcionando passar o productsCount como parâmetro
                    //para o "SearchProductWithEanPluOrNameWidget" para apagar o
                    //textEditingController após a consulta dos produtos se encontrar
                    //algum produto
                    if (transferBetweenPackageProvider.productsCount > 0) {
                      //se for maior que 0 significa que deu certo a consulta e
                      //por isso pode apagar o que foi escrito no campo de
                      //consulta
                      _consultProductController.clear();
                    }
                  },
                  consultProductController: _consultProductController,
                ),
                TransferBetweenPackageJustificationsAndStocksDropwdownWidget(
                  dropDownFormKey: _dropDownFormKey,
                ),
              ],
            ),
            if (transferBetweenPackageProvider.isLoadingProducts)
              Expanded(
                child: ConsultingWidget.consultingWidget(
                  title: 'Consultando produtos',
                ),
              ),
            if (transferBetweenPackageProvider.errorMessageGetProducts != "")
              ErrorMessage(
                errorMessage:
                    transferBetweenPackageProvider.errorMessageGetProducts,
              ),
            if (!transferBetweenPackageProvider.isLoadingProducts)
              TransferBetweenPackageProductsItems(
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
