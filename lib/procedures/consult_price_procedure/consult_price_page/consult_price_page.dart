import 'package:celta_inventario/procedures/consult_price_procedure/consult_price_page/consult_price_items.dart';
import 'package:celta_inventario/procedures/consult_price_procedure/consult_price_page/consult_price_widget.dart';
import 'package:celta_inventario/procedures/consult_price_procedure/consult_price_page/consult_price_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/consulting_widget.dart';

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
      // Provider.of<consultPriceProvider>(context, listen: false)
      //     .clearProducts();
    }
    isLoaded = true;
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
          ConsultPriceWidget(
            consultPriceProvider: consultPriceProvider,
            docCode: internalEnterpriseCode,
          ),
          if (consultPriceProvider.isLoading)
            Expanded(
              child: ConsultingWidget.consultingWidget(
                  title: 'Consultando produtos'),
            ),
          if (!consultPriceProvider.isLoading)
            ConsultPriceItems(
              consultPriceProvider: consultPriceProvider,
              internalEnterpriseCode: internalEnterpriseCode,
            ),
          if (MediaQuery.of(context).viewInsets.bottom == 0)
            Container(
              width: double.infinity,
              color: Colors.amber[600],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            consultPriceProvider.orderByDownPrice();
                          },
                          icon: Icon(
                            Icons.arrow_upward,
                          ),
                        ),
                        Text("Preço"),
                        IconButton(
                          onPressed: () {
                            consultPriceProvider.orderByUpPrice();
                          },
                          icon: Icon(
                            Icons.arrow_downward,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
