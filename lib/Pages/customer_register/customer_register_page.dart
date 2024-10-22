import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../providers/providers.dart';
import 'customer_register.dart';

class CustomerRegisterPage extends StatefulWidget {
  const CustomerRegisterPage({Key? key}) : super(key: key);

  @override
  State<CustomerRegisterPage> createState() => _CustomerRegisterPageState();
}

class _CustomerRegisterPageState extends State<CustomerRegisterPage> {
  int _selectedIndex = 0;

  final emailController = TextEditingController();
  final telephoneController = TextEditingController();
  final dddController = TextEditingController();
  final nameController = TextEditingController();
  final reducedNameController = TextEditingController();
  final cpfCnpjController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  final passwordController = TextEditingController();

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

  bool _isValidFormKey() {
    CustomerRegisterProvider customerRegisterProvider =
        Provider.of(context, listen: false);

    AddressProvider addressProvider = Provider.of(context, listen: false);
    if (_selectedIndex == 0) {
      setState(() {
        customerRegisterProvider.personFormKeyIsValid =
            _personFormKey.currentState!.validate();
      });
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
  dispose() {
    super.dispose();

    emailController.dispose();
    telephoneController.dispose();
    dddController.dispose();
    nameController.dispose();
    reducedNameController.dispose();
    cpfCnpjController.dispose();
    dateOfBirthController.dispose();
    passwordConfirmationController.dispose();
    passwordController.dispose();
  }

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        _isValidFormKey();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = <Widget>[
      CustomerRegisterPersonalDataPage(
        personFormKey: _personFormKey,
        validateFormKey: _isValidFormKey,
        cpfCnpjController: cpfCnpjController,
        nameController: nameController,
        passwordConfirmationController: passwordConfirmationController,
        passwordController: passwordController,
        reducedNameController: reducedNameController,
        dateOfBirthController: dateOfBirthController,
      ),
      AddressComponent(
        validateAdressFormKey: _isValidFormKey,
        adressFormKey: _adressFormKey,
        canInsertMoreThanOneAddress: true,
      ),
      CustomerRegisterEmailPage(
        emailFormKey: _emailFormKey,
        validateAdressFormKey: _isValidFormKey,
        emailController: emailController,
      ),
      CustomerRegisterTelephonePage(
        telephoneFormKey: _telephoneFormKey,
        validateTelephoneFormKey: _isValidFormKey,
        dddController: dddController,
        telephoneController: telephoneController,
      ),
      CustomerRegisterAddPage(
        nameController: nameController,
        cpfCnpjController: cpfCnpjController,
        reducedNameController: reducedNameController,
        dateOfBirthController: dateOfBirthController,
      ),
    ];

    CustomerRegisterProvider customerRegisterProvider = Provider.of(context);
    AddressProvider addressProvider = Provider.of(context);
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        customerRegisterProvider.clearAllDataInformed(
          addressProvider: addressProvider,
          emailController: emailController,
          telephoneController: telephoneController,
          dddController: dddController,
          nameController: nameController,
          reducedNameController: reducedNameController,
          cpfCnpjController: cpfCnpjController,
          dateOfBirthController: dateOfBirthController,
          passwordConfirmationController: passwordConfirmationController,
          passwordController: passwordController,
        );
      },
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: PopScope(
          canPop: canExitPage(
            customerRegisterProvider: customerRegisterProvider,
            addressProvider: addressProvider,
          ),
          onPopInvokedWithResult: (value, __) {
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
                bottomNavigationBar: CustomerRegisterBottomNavigationItems(
                  hasAddressInformed: _hasAdressInformed(addressProvider),
                  updateSelectedIndex: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  isValidFormKey: _isValidFormKey,
                  selectedIndex: _selectedIndex,
                ),
                body: _pages.elementAt(_selectedIndex),
                floatingActionButton: _selectedIndex == 4
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomerRegisterClearAllData(
                            nameController: nameController,
                            emailController: emailController,
                            telephoneController: telephoneController,
                            dddController: dddController,
                            reducedNameController: reducedNameController,
                            cpfCnpjController: cpfCnpjController,
                            dateOfBirthController: dateOfBirthController,
                            passwordConfirmationController:
                                passwordConfirmationController,
                            passwordController: passwordController,
                          ),
                          CustomerRegisterFloatingActionButton(
                            nameController: nameController,
                            reducedNameController: reducedNameController,
                            cpfCnpjController: cpfCnpjController,
                            dateOfBirthController: dateOfBirthController,
                            emailController: emailController,
                            telephoneController: telephoneController,
                            dddController: dddController,
                            passwordController: passwordController,
                            passwordConfirmationController:
                                passwordConfirmationController,
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
                                customerRegisterProvider
                                    .telephoneFormKeyIsValid = false;
                                _selectedIndex = 0;
                              });
                            },
                          )
                        ],
                      )
                    : null,
              ),
              loadingWidget(addressProvider.isLoadingCep),
              loadingWidget(customerRegisterProvider.isLoadingInsertCustomer),
            ],
          ),
        ),
      ),
    );
  }
}
