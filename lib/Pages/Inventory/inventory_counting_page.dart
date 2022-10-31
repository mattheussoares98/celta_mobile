import 'package:celta_inventario/utils/consulting_widget.dart';
import 'package:celta_inventario/utils/try_again.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/inventory_model.dart';
import '../../Components/Procedures_items_widgets/inventory_counting_items.dart';
import '../../providers/inventory_counting_provider.dart';

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
    InventoryCountingProvider inventoryCountingProvider =
        Provider.of(context, listen: true);

    if (!isLoaded) {
      inventoryCountingProvider.getCountings(
        inventoryProcessCode: inventorys.codigoInternoInventario,
        context: context,
      );
    }
    isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    InventoryCountingProvider inventoryCountingProvider =
        Provider.of(context, listen: true);
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
          if (inventoryCountingProvider.isLoadingCountings)
            Expanded(
                child: ConsultingWidget.consultingWidget(
                    title: 'Consultando contagens')),
          if (inventoryCountingProvider.errorMessage != '')
            Expanded(
              child: TryAgainWidget.tryAgain(
                errorMessage: inventoryCountingProvider.errorMessage,
                request: () async => setState(() {
                  inventoryCountingProvider.getCountings(
                    inventoryProcessCode: inventorys.codigoInternoInventario,
                    context: context,
                  );
                }),
              ),
            ),
          if (inventoryCountingProvider.errorMessage == "" &&
              !inventoryCountingProvider.isLoadingCountings)
            const Expanded(child: const InventoryCountingItems()),
        ],
      ),
    );
  }
}
