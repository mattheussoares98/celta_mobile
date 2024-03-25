import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/customer_register/customer_register.dart';
import '../../components/global_widgets/global_widgets.dart';
import '../../providers/providers.dart';
import 'customer_register.dart';

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

    AddressProvider addressProvider = Provider.of(context, listen: false);
    if (_selectedIndex == 0) {
      customerRegisterProvider.personFormKeyIsValid =
          _personFormKey.currentState!.validate();
      return customerRegisterProvider.personFormKeyIsValid;
    }
    if (_selectedIndex == 1) {
      addressProvider.addressFormKeyIsValid =
          _adressFormKey.currentState!.validate();

      return addressProvider.addressFormKeyIsValid;
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

  bool _hasAdressInformed(
    AddressProvider addressProvider,
  ) {
    return addressProvider.addressController.text.isNotEmpty ||
        addressProvider.cityController.text.isNotEmpty ||
        addressProvider.complementController.text.isNotEmpty ||
        addressProvider.districtController.text.isNotEmpty ||
        addressProvider.selectedStateDropDown.value != null ||
        addressProvider.numberController.text.isNotEmpty ||
        addressProvider.referenceController.text.isNotEmpty ||
        addressProvider.cepController.text.isNotEmpty;
  }

  void _onItemTapped({
    required int index,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    AddressProvider addressProvider = Provider.of(context, listen: false);

    bool hasAdressInformed = _hasAdressInformed(addressProvider);

    String errorMessage = "Informe os dados necessários!";
    if (hasAdressInformed && addressProvider.addressFormKeyIsValid) {
      errorMessage =
          "Adicione o endereço ou apague os dados para mudar de tela!";
    } else if (hasAdressInformed && !addressProvider.addressFormKeyIsValid) {
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

  bool canExitPage({
    required CustomerRegisterProvider customerRegisterProvider,
    required AddressProvider addressProvider,
  }) {
    if (_selectedIndex == 1 && _hasAdressInformed(addressProvider)) {
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
      AddressComponent(
        validateAdressFormKey: _formKeyIsValid,
        adressFormKey: _adressFormKey,
        canInsertMoreThanOneAddress: true,
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
    AddressProvider addressProvider = Provider.of(context);
    return PopScope(
      canPop: canExitPage(
        customerRegisterProvider: customerRegisterProvider,
        addressProvider: addressProvider,
      ),
      onPopInvoked: (value) {
        if (value == true) {
          addressProvider.clearAddresses();
          addressProvider.clearAddressControllers(clearCep: true);
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text(
                appBarTitles[_selectedIndex],
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
                    hasDataAndIsValid: addressProvider.addressFormKeyIsValid &&
                        addressProvider.addressesCount > 0,
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
                            (addressProvider.addressFormKeyIsValid &&
                                addressProvider.addressesCount > 0),
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
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: FloatingActionButton(
                          tooltip: "Limpar todos os dados do pedido",
                          onPressed: customerRegisterProvider
                                      .isLoadingInsertCustomer ||
                                  customerRegisterProvider
                                      .nameController.text.isEmpty
                              ? null
                              : () {
                                  ShowAlertDialog.showAlertDialog(
                                    context: context,
                                    title: "Apagar TODOS dados",
                                    subtitle:
                                        "Deseja realmente limpar todos os dados do pedido?",
                                    function: () {
                                      customerRegisterProvider
                                          .clearAllDataInformed(
                                              addressProvider);
                                    },
                                  );
                                },
                          child: const Icon(Icons.delete, color: Colors.white),
                          backgroundColor: customerRegisterProvider
                                      .isLoadingInsertCustomer ||
                                  customerRegisterProvider
                                      .nameController.text.isEmpty
                              ? Colors.grey.withOpacity(0.75)
                              : Colors.red.withOpacity(0.75),
                        ),
                      ),
                      CustomerRegisterFloatingActionButton(
                        changeSelectedIndexToAddAddres: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                        changeFormKeysToInvalid: () {
                          setState(() {
                            customerRegisterProvider.personFormKeyIsValid =
                                false;
                            addressProvider.addressFormKeyIsValid = false;
                            customerRegisterProvider.emailFormKeyIsValid =
                                false;
                            customerRegisterProvider.telephoneFormKeyIsValid =
                                false;
                            _selectedIndex = 0;
                          });
                        },
                      ),
                    ],
                  )
                : null,
          ),
          loadingWidget(
            message: "Consultando CEP...",
            isLoading: addressProvider.isLoadingCep,
          ),
          loadingWidget(
            message: "Cadastrando cliente...",
            isLoading: customerRegisterProvider.isLoadingInsertCustomer,
          ),
        ],
      ),
    );
  }
}
