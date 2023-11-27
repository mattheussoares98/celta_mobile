import 'package:celta_inventario/components/Buy_request/buy_request_enterprises.dart';
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
    if (buyRequestProvider.enterprisesCount > 0) return;
    await buyRequestProvider.getEnterprises(
        context: context, isSearchingAgain: false);
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: BuyRequestEnterprises(),
    );
  }
}
