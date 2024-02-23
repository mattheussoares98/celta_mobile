import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/customer_register/customer_register.dart';
import '../../providers/providers.dart';

class CustomerRegisterAddPage extends StatefulWidget {
  const CustomerRegisterAddPage({Key? key}) : super(key: key);

  @override
  State<CustomerRegisterAddPage> createState() =>
      _CustomerRegisterAddPageState();
}

class _CustomerRegisterAddPageState extends State<CustomerRegisterAddPage> {
  @override
  Widget build(BuildContext context) {
    CustomerRegisterProvider customerRegisterProvider =
        Provider.of(context, listen: true);
    return SingleChildScrollView(
      child: Column(
        children: [
          if (customerRegisterProvider.nameController.text.isNotEmpty)
            CustomerRegisterPersonalDataInformeds(
              customerRegisterProvider: customerRegisterProvider,
            ),
          if (customerRegisterProvider.adressesCount > 0)
            const CustomerRegisterAdressesInformeds(),
          if (customerRegisterProvider.emailsCount > 0)
            const CustomerRegisterEmailsInformeds(),
          if (customerRegisterProvider.telephonesCount > 0)
            const CustomerRegisterTelephonesInformeds(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
