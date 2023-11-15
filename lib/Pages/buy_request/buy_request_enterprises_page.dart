import 'package:celta_inventario/providers/buy_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuyRequestEnterprisesPage extends StatefulWidget {
  const BuyRequestEnterprisesPage({Key? key}) : super(key: key);

  @override
  State<BuyRequestEnterprisesPage> createState() =>
      _BuyRequestEnterprisesPageState();
}

class _BuyRequestEnterprisesPageState extends State<BuyRequestEnterprisesPage> {
  @override
  void initState() {
    super.initState();

    _getEnterprises();
  }

  Future<void> _getEnterprises() async {
    BuyRequestProvider buyRequestProvider = Provider.of(context, listen: false);
    await buyRequestProvider.getEnterprises(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return const Text("Empresas");
  }
}
