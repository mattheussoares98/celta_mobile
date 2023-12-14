import 'package:celta_inventario/components/Customer_register/customer_register_adresses_informeds.dart';
import 'package:celta_inventario/components/Customer_register/customer_register_emails_informeds.dart';
import 'package:celta_inventario/components/Customer_register/customer_register_personal_data_informeds.dart';
import 'package:celta_inventario/components/Customer_register/customer_register_telephones_informeds.dart';
import 'package:celta_inventario/providers/customer_register_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
