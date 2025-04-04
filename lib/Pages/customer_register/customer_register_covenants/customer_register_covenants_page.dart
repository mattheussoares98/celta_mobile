import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Models/models.dart';
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

  List<CustomerRegisterCovenantModel> notInsertedCovenants(
    CustomerRegisterProvider customerRegisterProvider,
  ) {
    if (customerRegisterProvider.customer?.CustomerCovenants == null) {
      return customerRegisterProvider.covenants;
    }

    return customerRegisterProvider.covenants
        .where((e) =>
            customerRegisterProvider.customer?.CustomerCovenants
                ?.where(
                  (x) => e.Codigo_Convenio?.toInt() == x.covenant?.Code,
                )
                .toList()
                .isEmpty ==
            true)
        .toList();
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
            if (customerRegisterProvider.errorMessage != "" &&
                customerRegisterProvider.covenants.isEmpty)
              searchAgain(
                errorMessage: customerRegisterProvider.errorMessage,
                request: customerRegisterProvider.loadCovenants,
              ),
            if (notInsertedCovenants(customerRegisterProvider).isNotEmpty)
              LoadedCovenants(
                notInsertedCovenants:
                    notInsertedCovenants(customerRegisterProvider),
              ),
            if ((customerRegisterProvider.customer?.CustomerCovenants?.length ??
                    0) >
                0)
              const BindedCovenants(),
          ],
        ),
      ),
    );
  }
}
