import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/buy_request/buy_request.dart';
import '../../providers/providers.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getEnterprises();
    });
  }

  Future<void> _getEnterprises() async {
    BuyRequestProvider buyRequestProvider = Provider.of(context, listen: false);
    if (buyRequestProvider.enterprisesCount > 0) return;
    await buyRequestProvider.getEnterprises(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: BuyRequestEnterprises(),
    );
  }
}
