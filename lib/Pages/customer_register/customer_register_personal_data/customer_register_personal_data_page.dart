import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../providers/providers.dart';
import 'customer_register_personal_data.dart';

class CustomerRegisterPersonalDataPage extends StatefulWidget {
  final GlobalKey<FormState> personFormKey;
  final Function() validateFormKey;
  const CustomerRegisterPersonalDataPage({
    required this.personFormKey,
    required this.validateFormKey,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomerRegisterPersonalDataPage> createState() =>
      _CustomerRegisterPersonalDataPageState();
}

class _CustomerRegisterPersonalDataPageState
    extends State<CustomerRegisterPersonalDataPage> {
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode reducedNameFocusNode = FocusNode();
  final FocusNode cpfCnpjFocusNode = FocusNode();
  final FocusNode sexTypeFocusNode = FocusNode();
  final FocusNode dateOfBirthFocusNode = FocusNode();

  ValueNotifier<String?> _selectedSexDropDown = ValueNotifier<String?>("");

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    CustomerRegisterProvider customerRegisterProvider =
        Provider.of(context, listen: true);
    _selectedSexDropDown.value =
        customerRegisterProvider.selectedSexDropDown.value;
  }

  @override
  void dispose() {
    super.dispose();
    nameFocusNode.dispose();
    reducedNameFocusNode.dispose();
    cpfCnpjFocusNode.dispose();
    sexTypeFocusNode.dispose();
    dateOfBirthFocusNode.dispose();
  }

  bool cpfCnpjEnabled = true;
  void updateCpfCnpjEnabled() {
    CustomerRegisterProvider customerRegisterProvider =
        Provider.of(context, listen: false);

    if (customerRegisterProvider.cpfCnpjController.text.length > 11) {
      setState(() {
        cpfCnpjEnabled = false;
      });
    } else {
      setState(() {
        cpfCnpjEnabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    updateCpfCnpjEnabled();

    return SingleChildScrollView(
      primary: false,
      child: Form(
        key: widget.personFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            NameField(
              nameFocusNode: nameFocusNode,
              cpfCnpjFocusNode: cpfCnpjFocusNode,
              validateFormKey: widget.validateFormKey,
            ),
            CpfOrCnpjField(
              cpfCnpjFocusNode: cpfCnpjFocusNode,
              reducedNameFocusNode: reducedNameFocusNode,
              updateCpfCnpjEnabled: updateCpfCnpjEnabled,
              validateFormKey: widget.validateFormKey,
            ),
            ReducedNameField(
              reducedNameFocusNode: reducedNameFocusNode,
              dateOfBirthFocusNode: dateOfBirthFocusNode,
              validateFormKey: widget.validateFormKey,
            ),
            BirthField(
              dateOfBirthFocusNode: dateOfBirthFocusNode,
              sexTypeFocusNode: sexTypeFocusNode,
              validateFormKey: widget.validateFormKey,
            ),
            if (cpfCnpjEnabled)
              SexType(
                selectedSexDropDown: _selectedSexDropDown,
                sexTypeFocusNode: sexTypeFocusNode,
                cpfCnpjEnabled: cpfCnpjEnabled,
                validateFormKey: widget.validateFormKey,
              ),
            const ClearData(),
          ],
        ),
      ),
    );
  }
}
