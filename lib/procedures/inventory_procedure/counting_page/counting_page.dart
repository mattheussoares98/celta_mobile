import 'package:celta_inventario/utils/consulting_widget.dart';
import 'package:celta_inventario/utils/try_again.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/inventory_model.dart';
import 'counting_items.dart';
import 'counting_provider.dart';

class CountingPage extends StatefulWidget {
  const CountingPage({Key? key}) : super(key: key);

  @override
  State<CountingPage> createState() => _CountingPageState();
}

class _CountingPageState extends State<CountingPage> {
  bool isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final inventorys =
        ModalRoute.of(context)!.settings.arguments as InventoryModel;
    CountingProvider countingProvider = Provider.of(context, listen: true);

    if (!isLoaded) {
      countingProvider.getCountings(
        inventoryProcessCode: inventorys.codigoInternoInventario,
        userIdentity: UserIdentity.identity,
      );
    }
    isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    CountingProvider countingProvider = Provider.of(context, listen: true);
    final inventorys =
        ModalRoute.of(context)!.settings.arguments as InventoryModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CONTAGENS',
        ),
      ),
      body: Column(
        children: [
          if (countingProvider.isLoadingCountings)
            Expanded(
                child: ConsultingWidget.consultingWidget(
                    title: 'Consultando contagens')),
          if (countingProvider.errorMessage != '')
            Expanded(
              child: TryAgainWidget.tryAgain(
                errorMessage: countingProvider.errorMessage,
                request: () async => setState(() {
                  countingProvider.getCountings(
                    inventoryProcessCode: inventorys.codigoInternoInventario,
                    userIdentity: UserIdentity.identity,
                  );
                }),
              ),
            ),
          if (countingProvider.errorMessage == "" &&
              !countingProvider.isLoadingCountings)
            const Expanded(child: const CountingItems()),
        ],
      ),
    );
  }
}
