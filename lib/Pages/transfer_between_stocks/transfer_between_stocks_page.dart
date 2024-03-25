import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
import '../../components/transfer_between_stocks/transfer_between_stocks.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';

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

    return Stack(
      children: [
        PopScope(
          canPop: !transferBetweenStocksProvider.isLoadingAdjustStock &&
              !transferBetweenStocksProvider.isLoadingProducts &&
              !transferBetweenStocksProvider
                  .isLoadingTypeStockAndJustifications,
          onPopInvoked: (value) {
            if (value == true) {
              transferBetweenStocksProvider
                  .clearProductsJustificationsStockTypesAndJsonAdjustStock();
            }  
          },
          child: Scaffold(
            resizeToAvoidBottomInset: kIsWeb ? false : true,
            appBar: AppBar(
              title: const FittedBox(
                child: Text(
                  'TRANSFERÊNCIA ENTRE ESTOQUES',
                ),
              ),
            ),
            body: SingleChildScrollView(
              primary: false,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      SearchWidget(
                        focusNodeConsultProduct: transferBetweenStocksProvider
                            .consultProductFocusNode,
                        isLoading: transferBetweenStocksProvider
                                .isLoadingProducts ||
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
                                    transferBetweenStocksProvider
                                        .isLoadingProducts
                                ? null
                                : () async {
                                    await transferBetweenStocksProvider
                                        .getStockTypeAndJustifications(context);

                                    Future.delayed(
                                        const Duration(milliseconds: 500), () {
                                      if (_keyJustifications.currentState !=
                                              null &&
                                          _keyOriginStockType.currentState !=
                                              null &&
                                          _keyDestinyStockType.currentState !=
                                              null) {
                                        _keyJustifications.currentState!
                                            .reset();
                                        _keyOriginStockType.currentState!
                                            .reset();
                                        _keyDestinyStockType.currentState!
                                            .reset();
                                      }
                                    });
                                  },
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (transferBetweenStocksProvider.errorMessageGetProducts !=
                      "")
                    ErrorMessage(
                      errorMessage:
                          transferBetweenStocksProvider.errorMessageGetProducts,
                    ),
                  if (!transferBetweenStocksProvider.isLoadingProducts)
                    TransferBetweenStocksProductsItems(
                      internalEnterpriseCode:
                          arguments["CodigoInterno_Empresa"],
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
        ),
        loadingWidget(
          message: 'Consultando produtos...',
          isLoading: transferBetweenStocksProvider.isLoadingProducts,
        ),
        loadingWidget(
          message: "Confirmando ajuste...",
          isLoading: transferBetweenStocksProvider.isLoadingAdjustStock,
        ),
        loadingWidget(
          message: "Consultando estoques e justificativas...",
          isLoading:
              transferBetweenStocksProvider.isLoadingTypeStockAndJustifications,
        ),
      ],
    );
  }
}
