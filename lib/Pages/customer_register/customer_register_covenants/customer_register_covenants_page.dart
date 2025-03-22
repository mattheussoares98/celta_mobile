import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../customer_register.dart';
import '../../../providers/providers.dart';

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
        if (customerRegisterProvider.covenants.isEmpty) {
          customerRegisterProvider.loadCovenants();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomerRegisterProvider customerRegisterProvider = Provider.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (customerRegisterProvider.errorMessageLoadCovenants != "" &&
                customerRegisterProvider.covenants.isEmpty)
              searchAgain(
                errorMessage:
                    customerRegisterProvider.errorMessageLoadCovenants,
                request: customerRegisterProvider.loadCovenants,
              ),
            if (customerRegisterProvider.covenants.isNotEmpty)
              const LoadedCovenants(),
            if (customerRegisterProvider.bindedCovenants.isNotEmpty)
              const BindedCovenants(),
          ],
        ),
      ),
    );
  }
}
