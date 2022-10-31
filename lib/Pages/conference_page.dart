import 'package:celta_inventario/Components/Buttons/conference_consult_product_without_ean_button.dart';
import 'package:celta_inventario/Components/search_product_with_ean_plu_or_name_widget.dart';
import 'package:celta_inventario/Components/Procedures_items_widgets/conference_items.dart';
import 'package:celta_inventario/providers/conference_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/consulting_widget.dart';

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

  final TextEditingController _consultProductController =
      TextEditingController();

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
          SearchProductWithEanPluOrNameWidget(
            isLoading: conferenceProvider.consultingProducts ||
                conferenceProvider.isUpdatingQuantity,
            onPressSearch: () async =>
                await conferenceProvider.getProductByPluEanOrName(
              docCode: docCode,
              controllerText: _consultProductController.text,
              context: context,
            ),
            consultProductController: _consultProductController,
            productsCount: conferenceProvider.productsCount,
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
            ConferenceConsultProductWithoutEanButton(
              docCode: docCode,
              conferenceProvider: conferenceProvider,
            ),
        ],
      ),
    );
  }
}
