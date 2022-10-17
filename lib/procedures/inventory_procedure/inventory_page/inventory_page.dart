import 'package:celta_inventario/utils/consulting_widget.dart';
import 'package:celta_inventario/utils/try_again.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/enterprise_inventory_model.dart';
import 'inventory_items.dart';
import 'inventory_provider.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  bool _isLoaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    EnterpriseInventoryModel enterprise =
        ModalRoute.of(context)!.settings.arguments as EnterpriseInventoryModel;

    if (!_isLoaded) {
      Provider.of<InventoryProvider>(context, listen: false).getInventory(
        enterpriseCode: enterprise.codigoInternoEmpresa.toString(),
        userIdentity: UserIdentity.identity,
      );
      _isLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    InventoryProvider inventoryProvider = Provider.of(context, listen: true);
    EnterpriseInventoryModel enterprise =
        ModalRoute.of(context)!.settings.arguments as EnterpriseInventoryModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'INVENTÁRIOS',
        ),
      ),
      body: Column(
        children: [
          if (inventoryProvider.isLoadingInventorys)
            Expanded(
                child: ConsultingWidget.consultingWidget(
                    title: 'Consultando inventários')),
          if (inventoryProvider.errorMessage != '')
            Expanded(
              child: TryAgainWidget.tryAgain(
                provider: inventoryProvider,
                errorMessage: inventoryProvider.errorMessage,
                request: () async => setState(() {
                  inventoryProvider.getInventory(
                    enterpriseCode: enterprise.codigoInternoEmpresa.toString(),
                    userIdentity: UserIdentity.identity,
                  );
                }),
              ),
            ),
          if (inventoryProvider.errorMessage == "" &&
              !inventoryProvider.isLoadingInventorys)
            const Expanded(child: const InventoryItems()),
        ],
      ),
    );
  }
}
