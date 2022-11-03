import 'package:celta_inventario/Components/Buttons/price_conference_order_products_buttons.dart';
import 'package:celta_inventario/Components/Procedures_items_widgets/price_conference_items.dart';
import 'package:celta_inventario/providers/price_conference_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Components/search_product_with_ean_plu_or_name_widget.dart';
import '../utils/consulting_widget.dart';

class PriceConferencePage extends StatefulWidget {
  const PriceConferencePage({Key? key}) : super(key: key);

  @override
  State<PriceConferencePage> createState() => _PriceConferencePageState();
}

class _PriceConferencePageState extends State<PriceConferencePage> {
  bool isLoaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isLoaded) {
      // Provider.of<onsultPriceProvider>(context, listen: false)
      //     .clearProducts();
    }
    isLoaded = true;
  }

  final TextEditingController _consultProductController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _consultProductController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PriceConferenceProvider priceConferenceProvider =
        Provider.of(context, listen: true);
    int codigoInternoEmpresa =
        ModalRoute.of(context)!.settings.arguments as int;

    return WillPopScope(
      onWillPop: () async {
        priceConferenceProvider.clearProducts();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'CONSULTA DE PREÇOS',
          ),
          leading: IconButton(
            onPressed: () {
              priceConferenceProvider.clearProducts();
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
          children: [
            SearchProductWithEanPluOrNameWidget(
              focusNodeConsultProduct:
                  priceConferenceProvider.consultProductFocusNode,
              isLoading: priceConferenceProvider.isLoading ||
                  priceConferenceProvider.isSendingToPrint,
              onPressSearch: () async {
                await priceConferenceProvider.getProductByPluEanOrName(
                  enterpriseCode: codigoInternoEmpresa,
                  controllerText: _consultProductController.text,
                  context: context,
                );

                //não estava funcionando passar o productsCount como parâmetro
                //para o "SearchProductWithEanPluOrNameWidget" para apagar o
                //textEditingController após a consulta dos produtos se encontrar
                //algum produto
                if (priceConferenceProvider.productsCount > 0) {
                  //se for maior que 0 significa que deu certo a consulta e
                  //por isso pode apagar o que foi escrito no campo de
                  //consulta
                  _consultProductController.clear();
                }
              },
              consultProductController: _consultProductController,
            ),
            if (priceConferenceProvider.isLoading)
              Expanded(
                child: ConsultingWidget.consultingWidget(
                  title: 'Consultando produtos',
                ),
              ),
            if (!priceConferenceProvider.isLoading)
              PriceConferenceItems(
                priceConferenceProvider: priceConferenceProvider,
                internalEnterpriseCode: codigoInternoEmpresa,
              ),
            if (MediaQuery.of(context).viewInsets.bottom == 0 &&
                priceConferenceProvider.productsCount > 1)
              //só mostra a opção de organizar se houver mais de um produto e se o teclado estiver fechado
              PriceConferenceOrderProductsButtons(
                  priceConferenceProvider: priceConferenceProvider)
          ],
        ),
      ),
    );
  }
}
