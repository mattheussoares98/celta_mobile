import 'package:celta_inventario/procedures/receipt_prodecure/products_conference_page/conference_consult_product.dart';
import 'package:celta_inventario/procedures/receipt_prodecure/products_conference_page/conference_consult_product_without_ean.dart';
import 'package:celta_inventario/procedures/receipt_prodecure/products_conference_page/conference_items.dart';
import 'package:celta_inventario/procedures/receipt_prodecure/products_conference_page/conference_provider.dart';
import 'package:celta_inventario/utils/show_error_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/consulting_widget.dart';
import '../../../utils/try_again.dart';

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
      Provider.of<ConferenceProvider>(context, listen: false).clearProducts();
    }
    isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    ConferenceProvider conferenceProvider = Provider.of(context, listen: true);
    int docCode = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PRODUTOS DA CONFERÊNCIA',
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ConferenceConsultProduct(
            conferenceProvider: conferenceProvider,
            docCode: docCode,
          ),
          if (conferenceProvider.consultingProducts)
            Expanded(
              child: ConsultingWidget.consultingWidget(
                  title: 'Consultando produtos'),
            ),
          if (!conferenceProvider.consultingProducts)
            ConferenceItems(
              docCode: docCode,
              conferenceProvider: conferenceProvider,
            ),
          if (MediaQuery.of(context).viewInsets.bottom == 0)
            ConferenceConsultProductWithoutEan(
              docCode: docCode,
              conferenceProvider: conferenceProvider,
            ),
        ],
      ),
    );
  }
}
