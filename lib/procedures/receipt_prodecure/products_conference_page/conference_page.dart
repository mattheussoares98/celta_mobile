import 'package:celta_inventario/procedures/receipt_prodecure/products_conference_page/conference_consult_product.dart';
import 'package:celta_inventario/procedures/receipt_prodecure/products_conference_page/conference_items.dart';
import 'package:celta_inventario/procedures/receipt_prodecure/products_conference_page/conference_provider.dart';
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
  bool _isLoaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    int docCode = ModalRoute.of(context)!.settings.arguments as int;

    if (!_isLoaded) {
      Provider.of<ConferenceProvider>(context, listen: true)
          .getProducts(docCode: docCode);

      _isLoaded = true;
    }
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ConferenceConsultProduct(conferenceProvider),
          if (conferenceProvider.isLoading)
            Expanded(
              child: ConsultingWidget.consultingWidget(
                  title: 'Consultando produtos do recebimento'),
            ),
          if (conferenceProvider.errorMessage != '' &&
              !conferenceProvider.isLoading)
            // && conferenceProvider.receiptCount == 0)
            SingleChildScrollView(
              child: TryAgainWidget.tryAgain(
                errorMessage: conferenceProvider.errorMessage,
                request: () async {
                  setState(() {
                    conferenceProvider.getProducts(docCode: docCode);
                  });
                },
              ),
            ),
          if (conferenceProvider.errorMessage != '' &&
              !conferenceProvider.isLoading)
            const Card(), //coloquei isso só pra aparecer a mensagem de erro no centro... no mainAxisAlignment da coluna está colocando espaço entre os itens
          if (!conferenceProvider.isLoading &&
              conferenceProvider.errorMessage == "")
            const Expanded(
              child: const ConferenceItems(),
            ),
        ],
      ),
    );
  }
}
