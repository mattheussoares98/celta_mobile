import 'package:celta_inventario/Pages/customer_register/customer_register_add_page.dart';
import 'package:celta_inventario/Pages/customer_register/customer_register_adresses_page.dart';
import 'package:celta_inventario/Pages/customer_register/customer_register_personal_data_page.dart';
import 'package:celta_inventario/Pages/customer_register/customer_register_email_page.dart';
import 'package:celta_inventario/Pages/customer_register/customer_register_telephones_page.dart';
import 'package:celta_inventario/components/Customer_register/customer_register_floating_action_button.dart';
import 'package:celta_inventario/components/Global_widgets/show_snackbar_message.dart';
import 'package:celta_inventario/providers/customer_register_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerRegisterPage extends StatefulWidget {
  const CustomerRegisterPage({Key? key}) : super(key: key);

  @override
  State<CustomerRegisterPage> createState() => _CustomerRegisterPageState();
}

class _CustomerRegisterPageState extends State<CustomerRegisterPage> {
  int _selectedIndex = 0;

  GlobalKey<FormState> _personFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _adressFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _telephoneFormKey = GlobalKey<FormState>();

  static const List appBarTitles = [
    "Dados pessoais",
    "Endereços",
    "E-mails",
    "Telefones",
    "Confirmação de dados",
  ];

  Stack iconAccordingFormIsValid({
    required IconData icon,
    required bool hasDataAndIsValid,
  }) {
    return Stack(
      children: [
        Icon(
          icon,
          size: 35,
        ),
        Positioned(
          top: 0,
          right: 0,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            maxRadius: 6,
            child: FittedBox(
              child: Icon(
                hasDataAndIsValid ? Icons.check_circle : Icons.cancel_rounded,
                color: hasDataAndIsValid
                    ? Theme.of(context).colorScheme.primary
                    : Colors.red,
                size: 40,
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool _formKeyIsValid() {
    CustomerRegisterProvider customerRegisterProvider =
        Provider.of(context, listen: false);
    if (_selectedIndex == 0) {
      customerRegisterProvider.personFormKeyIsValid =
          _personFormKey.currentState!.validate();
      return customerRegisterProvider.personFormKeyIsValid;
    }
    if (_selectedIndex == 1) {
      customerRegisterProvider.adressFormKeyIsValid =
          _adressFormKey.currentState!.validate();

      return customerRegisterProvider.adressFormKeyIsValid;
    }
    if (_selectedIndex == 2) {
      customerRegisterProvider.emailFormKeyIsValid =
          _emailFormKey.currentState!.validate();
      return customerRegisterProvider.emailFormKeyIsValid;
    }
    if (_selectedIndex == 3) {
      customerRegisterProvider.telephoneFormKeyIsValid =
          _telephoneFormKey.currentState!.validate();
      return customerRegisterProvider.telephoneFormKeyIsValid;
    }
    if (_selectedIndex == 4) {
      return true;
    } else {
      return false;
    }
  }

  bool _hasAdressInformed({
    required CustomerRegisterProvider customerRegisterProvider,
  }) {
    return customerRegisterProvider.adressController.text.isNotEmpty ||
        customerRegisterProvider.cityController.text.isNotEmpty ||
        customerRegisterProvider.complementController.text.isNotEmpty ||
        customerRegisterProvider.districtController.text.isNotEmpty ||
        customerRegisterProvider.selectedStateDropDown.value != null ||
        customerRegisterProvider.numberController.text.isNotEmpty ||
        customerRegisterProvider.referenceController.text.isNotEmpty ||
        customerRegisterProvider.cepController.text.isNotEmpty;
  }

  void _onItemTapped({
    required int index,
    // required SaleRequestProvider saleRequestProvider,
  }) {
    CustomerRegisterProvider customerRegisterProvider =
        Provider.of(context, listen: false);

    bool hasAdressInformed =
        _hasAdressInformed(customerRegisterProvider: customerRegisterProvider);

    String errorMessage = "Informe os dados necessários!";
    if (hasAdressInformed && customerRegisterProvider.adressFormKeyIsValid) {
      errorMessage =
          "Adicione o endereço ou apague os dados para mudar de tela!";
    } else if (hasAdressInformed &&
        !customerRegisterProvider.adressFormKeyIsValid) {
      errorMessage = "Corrija os dados e salve o endereço para mudar de tela!";
    }

    if (_formKeyIsValid() && !hasAdressInformed) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      ShowSnackbarMessage.showMessage(
        message: errorMessage,
        context: context,
      );
    }
  }

  bool canExitPage(CustomerRegisterProvider customerRegisterProvider) {
    if (_selectedIndex == 1 &&
        _hasAdressInformed(
          customerRegisterProvider: customerRegisterProvider,
        )) {
      // ShowSnackbarMessage.showMessage(
      //   message:
      //       "Termine de adicionar o endereço ou apague os dados para sair da página",
      //   context: context,
      // );
      return false;
    } else if (customerRegisterProvider.isLoadingInsertCustomer) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = <Widget>[
      CustomerRegisterPersonalDataPage(
        personFormKey: _personFormKey,
      ),
      CustomerRegisterAdressesPage(
        validateAdressFormKey: _formKeyIsValid,
        adressFormKey: _adressFormKey,
      ),
      CustomerRegisterEmailPage(
        emailFormKey: _emailFormKey,
        validateAdressFormKey: _formKeyIsValid,
      ),
      CustomerRegisterTelephonePage(
        telephoneFormKey: _telephoneFormKey,
        validateTelephoneFormKey: _formKeyIsValid,
      ),
      const CustomerRegisterAddPage(),
    ];

    CustomerRegisterProvider customerRegisterProvider = Provider.of(context);
    // customerRegisterProvider.changeIsLoadingInsertCustomer();
    return PopScope(
      canPop: canExitPage(customerRegisterProvider),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            appBarTitles[_selectedIndex],
          ),
          leading: IconButton(
            onPressed: !canExitPage(customerRegisterProvider)
                ? null
                : () {
                    if (canExitPage(customerRegisterProvider)) {
                      Navigator.of(context).pop();
                    }
                  },
            icon: const Icon(
              Icons.arrow_back_outlined,
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: iconAccordingFormIsValid(
                icon: Icons.person,
                hasDataAndIsValid:
                    customerRegisterProvider.personFormKeyIsValid,
              ),
              label: 'Dados',
            ),
            BottomNavigationBarItem(
              label: 'Endereço',
              icon: iconAccordingFormIsValid(
                icon: Icons.room_outlined,
                hasDataAndIsValid:
                    customerRegisterProvider.adressFormKeyIsValid &&
                        customerRegisterProvider.adressesCount > 0,
              ),
            ),
            BottomNavigationBarItem(
              icon: iconAccordingFormIsValid(
                icon: Icons.email_rounded,
                hasDataAndIsValid:
                    customerRegisterProvider.emailFormKeyIsValid &&
                        customerRegisterProvider.emailsCount > 0,
              ),
              label: 'E-mail',
            ),
            BottomNavigationBarItem(
              icon: iconAccordingFormIsValid(
                icon: Icons.phone,
                hasDataAndIsValid:
                    customerRegisterProvider.telephoneFormKeyIsValid &&
                        customerRegisterProvider.telephonesCount > 0,
              ),
              label: 'Telefone',
            ),
            BottomNavigationBarItem(
              icon: iconAccordingFormIsValid(
                icon: Icons.check,
                hasDataAndIsValid:
                    customerRegisterProvider.personFormKeyIsValid &&
                        (customerRegisterProvider.adressFormKeyIsValid &&
                            customerRegisterProvider.adressesCount > 0),
              ),
              label: 'Salvar',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          onTap: customerRegisterProvider.isLoadingInsertCustomer
              ? null
              : (index) {
                  _onItemTapped(
                    index: index,
                    // saleRequestProvider: saleRequestProvider,
                  );
                },
        ),
        body: _pages.elementAt(_selectedIndex),
        floatingActionButton: _selectedIndex == 4
            ? CustomerRegisterFloatingActionButton(
                selectedIndex: _selectedIndex,
                changeSelectedIndexToAddAddres: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
                changeFormKeysToInvalid: () {
                  setState(() {
                    customerRegisterProvider.personFormKeyIsValid = false;
                    customerRegisterProvider.adressFormKeyIsValid = false;
                    customerRegisterProvider.emailFormKeyIsValid = false;
                    customerRegisterProvider.telephoneFormKeyIsValid = false;
                    _selectedIndex = 0;
                  });
                },
              )
            : null,
      ),
    );
  }
}
