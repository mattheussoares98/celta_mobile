import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../providers/providers.dart';
import 'components/components.dart';

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
    AddressProvider addressProvider = Provider.of(context, listen: true);

    return SingleChildScrollView(
    primary: false, 
      child: Column(
        children: [
          if (customerRegisterProvider.nameController.text.isNotEmpty)
            CustomerRegisterPersonalDataInformeds(
              customerRegisterProvider: customerRegisterProvider,
            ),
          if (addressProvider.addressesCount > 0)
            const CustomerRegisterAddressesInformeds(isLoading: false),
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
