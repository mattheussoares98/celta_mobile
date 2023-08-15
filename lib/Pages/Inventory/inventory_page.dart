import 'package:celta_inventario/Components/Global_widgets/consulting_widget.dart';
import 'package:celta_inventario/Components/Global_widgets/try_again.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Components/Inventory/inventory_items.dart';
import '../../providers/inventory_provider.dart';

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

    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    if (!_isLoaded) {
      Provider.of<InventoryProvider>(context, listen: false).getInventory(
        enterpriseCode: arguments["CodigoInterno_Empresa"],
        userIdentity: UserIdentity.identity,
      );
      _isLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    InventoryProvider inventoryProvider = Provider.of(context, listen: true);
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

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
                errorMessage: inventoryProvider.errorMessage,
                request: () async => setState(() {
                  inventoryProvider.getInventory(
                    enterpriseCode: arguments["CodigoInterno_Empresa"],
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
