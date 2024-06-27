import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';
import 'components/components.dart';

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
    _consultedProductController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AdjustStockProvider adjustStockProvider =
        Provider.of(context, listen: true);
    ConfigurationsProvider configurationsProvider =
        Provider.of(context, listen: true);
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return Stack(
      children: [
        PopScope(
          canPop: !adjustStockProvider.isLoadingProducts &&
              !adjustStockProvider.isLoadingAdjustStock &&
              !adjustStockProvider.isLoadingTypeStockAndJustifications,
          onPopInvoked: (value) async {
            if (value == true) {
              adjustStockProvider
                  .clearProductsJustificationsStockTypesAndJsonAdjustStock();
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: kIsWeb ? false : true,
            appBar: AppBar(
              title: const Text(
                'AJUSTE DE ESTOQUE  ',
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
                    Row(
                      children: [
                        Expanded(
                          child: AdjustStockJustificationsStockDropwdownWidget(
                            dropDownFormKey: _dropDownFormKey,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.refresh,
                            size: 30,
                            color: adjustStockProvider
                                        .isLoadingTypeStockAndJustifications ||
                                    adjustStockProvider.isLoadingAdjustStock ||
                                    adjustStockProvider.isLoadingProducts
                                ? Colors.grey
                                : Theme.of(context).colorScheme.primary,
                          ),
                          tooltip: "Consultar justificativas e estoques",
                          onPressed: adjustStockProvider
                                      .isLoadingTypeStockAndJustifications ||
                                  adjustStockProvider.isLoadingAdjustStock ||
                                  adjustStockProvider.isLoadingProducts
                              ? null
                              : () async {
                                  await adjustStockProvider
                                      .getStockTypeAndJustifications(context);
                                },
                        ),
                      ],
                    ),
                  ],
                ),
                if (adjustStockProvider.errorMessageGetProducts != "")
                  ErrorMessage(
                    errorMessage: adjustStockProvider.errorMessageGetProducts,
                  ),
                AdjustStockProductsItems(
                    internalEnterpriseCode: arguments["CodigoInterno_Empresa"],
                    consultedProductController: _consultedProductController,
                    dropDownFormKey: _dropDownFormKey,
                    insertQuantityFormKey: _insertQuantityFormKey,
                    getProductWithCamera: () async {
                      FocusScope.of(context).unfocus();
                      _consultProductController.clear();

                      _consultProductController.text =
                          await ScanBarCode.scanBarcode(context);

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
        ),
        loadingWidget(
          message: "Consultando produtos...",
          isLoading: adjustStockProvider.isLoadingProducts,
        ),
        loadingWidget(
          message: "Confirmando ajuste...",
          isLoading: adjustStockProvider.isLoadingAdjustStock,
        ),
        loadingWidget(
          message: "Consultando estoques e justificativas...",
          isLoading: adjustStockProvider.isLoadingTypeStockAndJustifications,
        ),
      ],
    );
  }
}
