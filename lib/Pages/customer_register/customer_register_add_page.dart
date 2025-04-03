import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import 'customer_register.dart';

class CustomerRegisterAddPage extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController cpfCnpjController;
  final TextEditingController reducedNameController;
  final TextEditingController dateOfBirthController;
  const CustomerRegisterAddPage({
    required this.nameController,
    required this.cpfCnpjController,
    required this.reducedNameController,
    required this.dateOfBirthController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CustomerRegisterProvider customerRegisterProvider =
        Provider.of(context, listen: true);
    AddressProvider addressProvider = Provider.of(context, listen: true);

    return SingleChildScrollView(
      primary: false,
      child: Column(
        children: [
          if (nameController.text.isNotEmpty)
            CustomerRegisterPersonalDataInformeds(
              customerRegisterProvider: customerRegisterProvider,
              nameController: nameController,
              cpfCnpjController: cpfCnpjController,
              reducedNameController: reducedNameController,
              dateOfBirthController: dateOfBirthController,
            ),
          if (addressProvider.addressesCount > 0)
            CustomerRegisterAddressesInformeds(
              isLoading: false,
              addresses: customerRegisterProvider.customer?.Addresses ?? [],
            ),
          if (customerRegisterProvider.emailsCount > 0)
            const CustomerRegisterEmailsInformeds(),
          if (customerRegisterProvider.telephonesCount > 0)
            const CustomerRegisterTelephonesInformeds(),
          if (customerRegisterProvider.bindedCovenants.isNotEmpty)
            const BindedCovenants(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
