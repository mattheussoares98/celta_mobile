import 'package:celta_inventario/Pages/customer_register/customer_register_add_page.dart';
import 'package:celta_inventario/Pages/customer_register/customer_register_adresses_page.dart';
import 'package:celta_inventario/Pages/customer_register/customer_register_person_page.dart';
import 'package:celta_inventario/Pages/customer_register/customer_register_email_page.dart';
import 'package:celta_inventario/Pages/customer_register/customer_register_telephones_page.dart';
import 'package:celta_inventario/components/Global_widgets/show_error_message.dart';
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

  bool _personFormKeyIsValid = false;
  bool _adressFormKeyIsValid = false;
  bool _emailFormKeyIsValid = false;
  bool _telephoneFormKeyIsValid = false;

  bool _formKeyIsValid() {
    if (_selectedIndex == 0) {
      _personFormKeyIsValid = _personFormKey.currentState!.validate();
      return _personFormKeyIsValid;
    }
    if (_selectedIndex == 1) {
      _adressFormKeyIsValid = _adressFormKey.currentState!.validate();

      return _adressFormKeyIsValid;
    }
    if (_selectedIndex == 2) {
      _emailFormKeyIsValid = _emailFormKey.currentState!.validate();
      return _emailFormKeyIsValid;
    }
    if (_selectedIndex == 3) {
      _telephoneFormKeyIsValid = _telephoneFormKey.currentState!.validate();
      return _telephoneFormKeyIsValid;
    }
    if (_selectedIndex == 4) {
      return true;
    } else {
      return false;
    }
  }

  void _onItemTapped({
    required int index,
    // required SaleRequestProvider saleRequestProvider,
  }) {
    CustomerRegisterProvider customerRegisterProvider =
        Provider.of(context, listen: false);

    bool hasAdressInformed =
        customerRegisterProvider.adressController.text.isNotEmpty ||
            customerRegisterProvider.cityController.text.isNotEmpty ||
            customerRegisterProvider.complementController.text.isNotEmpty ||
            customerRegisterProvider.districtController.text.isNotEmpty ||
            customerRegisterProvider.selectedStateDropDown.value != null ||
            customerRegisterProvider.numberController.text.isNotEmpty ||
            customerRegisterProvider.referenceController.text.isNotEmpty ||
            customerRegisterProvider.cepController.text.isNotEmpty;

    String errorMessage =
        "Corrija os erros e salve o endereço para mudar de tela!";
    if (hasAdressInformed && _adressFormKeyIsValid) {
      errorMessage =
          "Adicione o endereço ou apague os dados para mudar de tela!";
    } else if (hasAdressInformed && !_adressFormKeyIsValid) {
      errorMessage = "Corrija os dados e salve o endereço para mudar de tela!";
    }

    if (_formKeyIsValid() && !hasAdressInformed) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      ShowErrorMessage.showErrorMessage(
        error: errorMessage,
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = <Widget>[
      CustomerRegisterPersonPage(
        validatePersonFormKey: _formKeyIsValid,
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
      CustomerRegisterTelephonesPage(telephoneFormKey: _telephoneFormKey),
      const CustomerRegisterAddPage(),
    ];

    CustomerRegisterProvider customerRegisterProvider = Provider.of(context);

    return WillPopScope(
      onWillPop: () async {
        //fazer algo que quiser quando o usuário clicar no botão de voltar
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "cadastro de clientes",
          ),
          leading: IconButton(
            onPressed: () {
              //fazer algo que quiser quando o usuário clicar no botão de voltar
              Navigator.of(context).pop();
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
                hasDataAndIsValid: _personFormKeyIsValid,
              ),
              label: 'Básico',
            ),
            BottomNavigationBarItem(
              label: 'Endereço',
              icon: iconAccordingFormIsValid(
                icon: Icons.room_outlined,
                hasDataAndIsValid: _adressFormKeyIsValid &&
                    customerRegisterProvider.adressessCount > 0,
              ),
            ),
            BottomNavigationBarItem(
              icon: iconAccordingFormIsValid(
                icon: Icons.email_rounded,
                hasDataAndIsValid: _emailFormKeyIsValid &&
                    customerRegisterProvider.emailsCount > 0,
              ),
              label: 'E-mail',
            ),
            BottomNavigationBarItem(
              icon: iconAccordingFormIsValid(
                icon: Icons.phone,
                hasDataAndIsValid: _telephoneFormKeyIsValid &&
                    customerRegisterProvider.telephoneCount > 0,
              ),
              label: 'Telefone',
            ),
            BottomNavigationBarItem(
              icon: iconAccordingFormIsValid(
                icon: Icons.check,
                hasDataAndIsValid: _personFormKeyIsValid ||
                    _adressFormKeyIsValid ||
                    _emailFormKeyIsValid ||
                    _telephoneFormKeyIsValid,
              ),
              label: 'Cadastrar',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            _onItemTapped(
              index: index,
              // saleRequestProvider: saleRequestProvider,
            );
          },
        ),
        body: _pages.elementAt(_selectedIndex),
      ),
    );
  }
}
