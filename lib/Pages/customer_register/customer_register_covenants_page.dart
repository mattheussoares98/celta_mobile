import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';

class CustomerRegisterCovenantsPage extends StatefulWidget {
  const CustomerRegisterCovenantsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomerRegisterCovenantsPage> createState() =>
      _CustomerRegisterCovenantsPageState();
}

class _CustomerRegisterCovenantsPageState
    extends State<CustomerRegisterCovenantsPage> {
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        CustomerRegisterProvider customerRegisterProvider = Provider.of(
          context,
          listen: false,
        );
        customerRegisterProvider.loadCovenants();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // CustomerRegisterProvider customerRegisterProvider = Provider.of(context);

    return const Stack(
      children: [
        Center(child: Text("Customer register covenant page")),
      ],
    );
  }
}
