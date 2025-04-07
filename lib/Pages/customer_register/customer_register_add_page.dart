import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import 'customer_register.dart';

class CustomerRegisterAddPage extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController cpfCnpjController;
  final TextEditingController reducedNameController;
  final TextEditingController dateOfBirthController;
  final String? selectedSex;
  const CustomerRegisterAddPage({
    required this.nameController,
    required this.cpfCnpjController,
    required this.reducedNameController,
    required this.dateOfBirthController,
    required this.selectedSex,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CustomerRegisterProvider customerRegisterProvider = Provider.of(context);

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
              selectedSex: selectedSex,
            ),
          if ((customerRegisterProvider.customer?.Addresses?.length ?? 0) > 0)
            CustomerRegisterAddressesInformeds(
              addresses: customerRegisterProvider.customer?.Addresses ?? [],
            ),
          if ((customerRegisterProvider.customer?.Emails?.length ?? 0) > 0)
            const CustomerRegisterEmailsInformeds(),
          if ((customerRegisterProvider.customer?.Telephones?.length ?? 0) > 0)
            const CustomerRegisterTelephonesInformeds(),
          if ((customerRegisterProvider.customer?.CustomerCovenants?.length ??
                  0) >
              0)
            const BindedCovenants(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
