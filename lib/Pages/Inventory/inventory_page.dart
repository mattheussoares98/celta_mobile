import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';

import '../../models/models.dart';
import '../../Pages/inventory/inventory.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';

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

    EnterpriseModel enterprise =
        ModalRoute.of(context)!.settings.arguments as EnterpriseModel;

    if (!_isLoaded) {
      Provider.of<InventoryProvider>(context, listen: false).getInventory(
        enterpriseCode: enterprise.Code,
        userIdentity: UserData.crossIdentity,
      );
      _isLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    InventoryProvider inventoryProvider = Provider.of(context, listen: true);
    EnterpriseModel enterprise =
        ModalRoute.of(context)!.settings.arguments as EnterpriseModel;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(
              'INVENTÁRIOS',
            ),
            actions: [
              IconButton(
                onPressed: inventoryProvider.isLoadingInventorys
                    ? null
                    : () async {
                        await inventoryProvider.getInventory(
                          enterpriseCode: enterprise.Code,
                          userIdentity: UserData.crossIdentity,
                          isConsultingAgain: true,
                        );
                      },
                tooltip: "Consultar inventários",
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await inventoryProvider.getInventory(
                enterpriseCode: enterprise.Code,
                userIdentity: UserData.crossIdentity,
                isConsultingAgain: true,
              );
            },
            child: Column(
              children: [
                if (inventoryProvider.errorMessage != '')
                  Expanded(
                    child: searchAgain(
                      errorMessage: inventoryProvider.errorMessage,
                      request: () async => setState(() {
                        inventoryProvider.getInventory(
                          enterpriseCode: enterprise.Code,
                          userIdentity: UserData.crossIdentity,
                        );
                      }),
                    ),
                  ),
                if (inventoryProvider.errorMessage == "" &&
                    !inventoryProvider.isLoadingInventorys)
                  const Expanded(child: const InventoryItems()),
              ],
            ),
          ),
        ),
        loadingWidget(inventoryProvider.isLoadingInventorys),
      ],
    );
  }
}
