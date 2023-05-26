import 'package:celta_inventario/Components/Global_widgets/consulting_widget.dart';
import 'package:celta_inventario/Components/Global_widgets/try_again.dart';
import 'package:celta_inventario/providers/inventory_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Components/Inventory/inventory_counting_items.dart';

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
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    InventoryProvider inventoryProvider = Provider.of(context, listen: true);

    if (!isLoaded) {
      inventoryProvider.getCountings(
        inventoryProcessCode: arguments["codigoInternoInventario"],
        context: context,
      );
    }
    isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    InventoryProvider inventoryProvider = Provider.of(context, listen: true);
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CONTAGENS',
        ),
      ),
      body: Column(
        children: [
          if (inventoryProvider.isLoadingCountings)
            Expanded(
              child: ConsultingWidget.consultingWidget(
                title: 'Consultando contagens',
              ),
            ),
          if (inventoryProvider.errorMessageCountings != '')
            Expanded(
              child: TryAgainWidget.tryAgain(
                errorMessage: inventoryProvider.errorMessageCountings,
                request: () async => setState(() {
                  inventoryProvider.getCountings(
                    inventoryProcessCode: arguments["codigoInternoInventario"],
                    context: context,
                  );
                }),
              ),
            ),
          if (inventoryProvider.errorMessageCountings == "" &&
              !inventoryProvider.isLoadingCountings)
            Expanded(
              child: InventoryCountingItems(
                codigoInternoEmpresa: arguments["codigoInternoEmpresa"],
              ),
            ),
        ],
      ),
    );
  }
}
