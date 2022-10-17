import 'package:celta_inventario/utils/consulting_widget.dart';
import 'package:celta_inventario/utils/try_again.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'enterprise_receipt_items.dart';
import 'enterprise_receipt_provider.dart';

class EnterpriseReceiptPage extends StatefulWidget {
  const EnterpriseReceiptPage({Key? key}) : super(key: key);

  @override
  State<EnterpriseReceiptPage> createState() => EnterpriseReceiptPageState();
}

class EnterpriseReceiptPageState extends State<EnterpriseReceiptPage> {
  getEnterprises(EnterpriseReceiptProvider enterpriseReceiptProvider) async {
    await enterpriseReceiptProvider.getEnterprises(
      userIdentity: UserIdentity.identity,
    );
  }

  @override
  void initState() {
    super.initState();
    EnterpriseReceiptProvider enterpriseReceiptProvider =
        Provider.of(context, listen: false);
    getEnterprises(enterpriseReceiptProvider);
  }

  @override
  Widget build(BuildContext context) {
    EnterpriseReceiptProvider enterpriseReceiptProvider =
        Provider.of<EnterpriseReceiptProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EMPRESAS',
        ),
      ),
      body: Column(
        children: [
          if (enterpriseReceiptProvider.isLoadingEnterprises)
            Expanded(
              child: ConsultingWidget.consultingWidget(
                  title: 'Consultando empresas'),
            ),
          if (enterpriseReceiptProvider.errorMessage != '')
            Expanded(
              child: TryAgainWidget.tryAgain(
                provider: enterpriseReceiptProvider,
                errorMessage: enterpriseReceiptProvider.errorMessage,
                request: () async =>
                    await getEnterprises(enterpriseReceiptProvider),
              ),
            ),
          if (enterpriseReceiptProvider.errorMessage == "" &&
              !enterpriseReceiptProvider.isLoadingEnterprises)
            const Expanded(child: EnterpriseReceiptItems()),
        ],
      ),
    );
  }
}
