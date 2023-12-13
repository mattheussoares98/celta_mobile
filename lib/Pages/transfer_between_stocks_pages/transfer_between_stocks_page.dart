import 'package:celta_inventario/components/Global_widgets/show_snackbar_message.dart';
import 'package:celta_inventario/components/Transfer_between_stocks/transfer_between_stocks_justifications_stocks_dropdown.dart';
import 'package:celta_inventario/components/Transfer_between_stocks/transfer_between_stocks_products_items.dart';
import 'package:celta_inventario/providers/configurations_provider.dart';
import 'package:celta_inventario/providers/transfer_between_stocks_provider.dart';
import 'package:celta_inventario/utils/scan_bar_code.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Components/Global_widgets/search_widget.dart';
import '../../components/Global_widgets/searching_widget.dart';

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
  final GlobalKey<FormFieldState> _keyJustifications = GlobalKey();
  final GlobalKey<FormFieldState> _keyOriginStockType = GlobalKey();
  final GlobalKey<FormFieldState> _keyDestinyStockType = GlobalKey();

  @override
  void dispose() {
    super.dispose();
    _consultProductController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TransferBetweenStocksProvider transferBetweenStocksProvider =
        Provider.of(context, listen: true);
    ConfigurationsProvider configurationsProvider =
        Provider.of(context, listen: true);
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return PopScope(
      canPop: !transferBetweenStocksProvider.isLoadingAdjustStock &&
          !transferBetweenStocksProvider.isLoadingProducts &&
          !transferBetweenStocksProvider.isLoadingTypeStockAndJustifications,
      onPopInvoked: (_) async {
        if (transferBetweenStocksProvider.isLoadingAdjustStock ||
            transferBetweenStocksProvider.isLoadingProducts ||
            transferBetweenStocksProvider.isLoadingTypeStockAndJustifications) {
          ShowSnackbarMessage.showMessage(
            message: "Aguarde o término do processamento",
            context: context,
            backgroundColor: Theme.of(context).colorScheme.primary,
          );
          return;
        }
        transferBetweenStocksProvider
            .clearProductsJustificationsStockTypesAndJsonAdjustStock();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: kIsWeb ? false : true,
        appBar: AppBar(
          title: const FittedBox(
            child: Text(
              'TRANSFERÊNCIA ENTRE ESTOQUES',
            ),
          ),
          leading: IconButton(
            onPressed: transferBetweenStocksProvider.isLoadingAdjustStock ||
                    transferBetweenStocksProvider.isLoadingProducts ||
                    transferBetweenStocksProvider
                        .isLoadingTypeStockAndJustifications
                ? null
                : () {
                    transferBetweenStocksProvider
                        .clearProductsJustificationsStockTypesAndJsonAdjustStock();
                    Navigator.of(context).pop();
                  },
            icon: const Icon(
              Icons.arrow_back_outlined,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  SearchWidget(
                    focusNodeConsultProduct:
                        transferBetweenStocksProvider.consultProductFocusNode,
                    isLoading:
                        transferBetweenStocksProvider.isLoadingProducts ||
                            transferBetweenStocksProvider.isLoadingAdjustStock,
                    onPressSearch: () async {
                      await transferBetweenStocksProvider.getProducts(
                        enterpriseCode: arguments["CodigoInterno_Empresa"],
                        controllerText: _consultProductController.text,
                        context: context,
                        configurationsProvider: configurationsProvider,
                      );

                      if (transferBetweenStocksProvider.productsCount > 0) {
                        _consultProductController.clear();
                      }
                    },
                    consultProductController: _consultProductController,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child:
                            TransferBetweenStocksJustificationsAndStocksDropwdownWidget(
                          dropDownFormKey: _dropDownFormKey,
                          keyJustifications: _keyJustifications,
                          keyOriginStockType: _keyOriginStockType,
                          keyDestinyStockType: _keyDestinyStockType,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.refresh,
                          size: 30,
                          color: transferBetweenStocksProvider
                                      .isLoadingTypeStockAndJustifications ||
                                  transferBetweenStocksProvider
                                      .isLoadingAdjustStock ||
                                  transferBetweenStocksProvider
                                      .isLoadingProducts
                              ? Colors.grey
                              : Theme.of(context).colorScheme.primary,
                        ),
                        tooltip: "Consultar justificativas e estoques",
                        onPressed: transferBetweenStocksProvider
                                    .isLoadingTypeStockAndJustifications ||
                                transferBetweenStocksProvider
                                    .isLoadingAdjustStock ||
                                transferBetweenStocksProvider.isLoadingProducts
                            ? null
                            : () async {
                                await transferBetweenStocksProvider
                                    .getStockTypeAndJustifications(context);

                                Future.delayed(
                                    const Duration(milliseconds: 500), () {
                                  if (_keyJustifications.currentState != null &&
                                      _keyOriginStockType.currentState !=
                                          null &&
                                      _keyDestinyStockType.currentState !=
                                          null) {
                                    _keyJustifications.currentState!.reset();
                                    _keyOriginStockType.currentState!.reset();
                                    _keyDestinyStockType.currentState!.reset();
                                  }
                                });
                              },
                      ),
                    ],
                  ),
                ],
              ),
              if (transferBetweenStocksProvider.isLoadingProducts)
                searchingWidget(
                  title: 'Consultando produtos',
                ),
              if (transferBetweenStocksProvider.errorMessageGetProducts != "")
                Text(
                  transferBetweenStocksProvider.errorMessageGetProducts,
                  style: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              if (!transferBetweenStocksProvider.isLoadingProducts)
                TransferBetweenStocksProductsItems(
                  internalEnterpriseCode: arguments["CodigoInterno_Empresa"],
                  consultedProductController: _consultedProductController,
                  dropDownFormKey: _dropDownFormKey,
                  insertQuantityFormKey: _insertQuantityFormKey,
                  getProductsWithCamera: () async {
                    FocusScope.of(context).unfocus();
                    _consultProductController.clear();

                    _consultProductController.text =
                        await ScanBarCode.scanBarcode(context);

                    if (_consultProductController.text == "") {
                      return;
                    }

                    await transferBetweenStocksProvider.getProducts(
                      enterpriseCode: arguments["CodigoInterno_Empresa"],
                      controllerText: _consultProductController.text,
                      context: context,
                      configurationsProvider: configurationsProvider,
                    );

                    if (transferBetweenStocksProvider.productsCount > 0) {
                      _consultProductController.clear();
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
