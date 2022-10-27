import 'package:celta_inventario/utils/consulting_widget.dart';
import 'package:celta_inventario/utils/try_again.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'enterprise_consult_price_items.dart';
import 'consult_price_provider.dart';

class EnterpriseConsultPricePage extends StatefulWidget {
  const EnterpriseConsultPricePage({Key? key}) : super(key: key);

  @override
  State<EnterpriseConsultPricePage> createState() =>
      EnterpriseConsultPricePageState();
}

class EnterpriseConsultPricePageState
    extends State<EnterpriseConsultPricePage> {
  bool isLoaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isLoaded) {
      Provider.of<EnterpriseConsultPriceProvider>(context, listen: false)
          .getEnterprises();
      isLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    EnterpriseConsultPriceProvider enterpriseConsultPriceProvider =
        Provider.of<EnterpriseConsultPriceProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EMPRESAS',
        ),
      ),
      body: Column(
        children: [
          if (enterpriseConsultPriceProvider.isLoading)
            Expanded(
              child: ConsultingWidget.consultingWidget(
                  title: 'Consultando empresas'),
            ),
          if (enterpriseConsultPriceProvider.errorMessage != '')
            Expanded(
              child: TryAgainWidget.tryAgain(
                errorMessage: enterpriseConsultPriceProvider.errorMessage,
                request: () async =>
                    await enterpriseConsultPriceProvider.getEnterprises(),
              ),
            ),
          if (enterpriseConsultPriceProvider.errorMessage == "" &&
              !enterpriseConsultPriceProvider.isLoading)
            const Expanded(child: EnterpriseConsultPriceItems()),
        ],
      ),
    );
  }
}
