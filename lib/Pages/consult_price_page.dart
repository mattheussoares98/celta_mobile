import 'package:celta_inventario/Components/Procedures_items_widgets/consult_price_items.dart';
import 'package:celta_inventario/components/buttons/consult_price_order_products_buttons.dart';
import 'package:celta_inventario/providers/consult_price_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Components/search_product_with_ean_plu_or_name_widget.dart';
import '../utils/consulting_widget.dart';

class ConsultPricePage extends StatefulWidget {
  const ConsultPricePage({Key? key}) : super(key: key);

  @override
  State<ConsultPricePage> createState() => _ConsultPricePageState();
}

class _ConsultPricePageState extends State<ConsultPricePage> {
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
    ConsultPriceProvider consultPriceProvider =
        Provider.of(context, listen: true);
    int internalEnterpriseCode =
        ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CONSULTA DE PREÇOS',
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SearchProductWithEanPluOrNameWidget(
            focusNodeConsultProduct:
                consultPriceProvider.consultProductFocusNode,
            isLoading: consultPriceProvider.isLoading ||
                consultPriceProvider.isSendingToPrint,
            onPressSearch: () async {
              await consultPriceProvider.getProductByPluEanOrName(
                enterpriseCode: internalEnterpriseCode,
                controllerText: _consultProductController.text,
                context: context,
              );

              //não estava funcionando passar o productsCount como parâmetro
              //para o "SearchProductWithEanPluOrNameWidget" para apagar o
              //textEditingController após a consulta dos produtos se encontrar
              //algum produto
              if (consultPriceProvider.productsCount > 0) {
                //se for maior que 0 significa que deu certo a consulta e
                //por isso pode apagar o que foi escrito no campo de
                //consulta
                _consultProductController.clear();
              }
            },
            consultProductController: _consultProductController,
          ),
          if (consultPriceProvider.isLoading)
            Expanded(
              child: ConsultingWidget.consultingWidget(
                title: 'Consultando produtos',
              ),
            ),
          if (!consultPriceProvider.isLoading)
            ConsultPriceItems(
              consultPriceProvider: consultPriceProvider,
              internalEnterpriseCode: internalEnterpriseCode,
            ),
          if (MediaQuery.of(context).viewInsets.bottom == 0 &&
              consultPriceProvider.productsCount > 1)
            //só mostra a opção de organizar se houver mais de um produto e se o teclado estiver fechado
            ConsultFilterProducts(consultPriceProvider: consultPriceProvider),
        ],
      ),
    );
  }
}
