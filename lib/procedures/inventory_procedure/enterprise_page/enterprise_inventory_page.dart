import 'package:celta_inventario/procedures/inventory_procedure/enterprise_page/enterprise_inventory_items.dart';
import 'package:celta_inventario/utils/consulting_widget.dart';
import 'package:celta_inventario/utils/try_again.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'enterprise_inventory_provider.dart';

class EnterpriseInventoryPage extends StatefulWidget {
  const EnterpriseInventoryPage({Key? key}) : super(key: key);

  @override
  State<EnterpriseInventoryPage> createState() =>
      EnterpriseInventoryPageState();
}

class EnterpriseInventoryPageState extends State<EnterpriseInventoryPage> {
  getEnterprises(
      EnterpriseInventoryProvider enterpriseInventoryProvider) async {
    await enterpriseInventoryProvider.getEnterprises(
      userIdentity: UserIdentity.identity,
    );
  }

  @override
  void initState() {
    super.initState();
    EnterpriseInventoryProvider enterpriseInventoryProvider =
        Provider.of(context, listen: false);
    getEnterprises(enterpriseInventoryProvider);
  }

  @override
  Widget build(BuildContext context) {
    EnterpriseInventoryProvider enterpriseInventoryProvider =
        Provider.of<EnterpriseInventoryProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EMPRESAS',
        ),
      ),
      body: Column(
        children: [
          if (enterpriseInventoryProvider.isLoadingEnterprises)
            Expanded(
              child: ConsultingWidget.consultingWidget(
                  title: 'Consultando empresas'),
            ),
          if (enterpriseInventoryProvider.errorMessage != '')
            Expanded(
              child: TryAgainWidget.tryAgain(
                errorMessage: enterpriseInventoryProvider.errorMessage,
                request: () async =>
                    await getEnterprises(enterpriseInventoryProvider),
              ),
            ),
          if (enterpriseInventoryProvider.errorMessage == "" &&
              !enterpriseInventoryProvider.isLoadingEnterprises)
            const Expanded(child: EnterpriseInventoryItems()),
        ],
      ),
    );
  }
}
