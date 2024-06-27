import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/providers.dart';
import 'enterprise_items.dart';

class EnterprisesPage extends StatefulWidget {
  const EnterprisesPage({Key? key}) : super(key: key);

  @override
  State<EnterprisesPage> createState() => _EnterprisesPageState();
}

class _EnterprisesPageState extends State<EnterprisesPage> {
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
      child: EnterpriseItems(checkBoxEnabled: true),
    );
  }
}
