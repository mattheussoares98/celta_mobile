import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../providers/providers.dart';
import 'customer_register_personal_data.dart';

class CustomerRegisterPersonalDataPage extends StatefulWidget {
  final GlobalKey<FormState> personFormKey;
  final Function() validateFormKey;
  final TextEditingController cpfCnpjController;
  final TextEditingController nameController;
  final TextEditingController passwordConfirmationController;
  final TextEditingController passwordController;
  final TextEditingController reducedNameController;
  final TextEditingController dateOfBirthController;
  const CustomerRegisterPersonalDataPage({
    required this.personFormKey,
    required this.validateFormKey,
    required this.cpfCnpjController,
    required this.nameController,
    required this.passwordConfirmationController,
    required this.passwordController,
    required this.reducedNameController,
    required this.dateOfBirthController,
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
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode passwordConfirmationFocusNode = FocusNode();

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
    passwordFocusNode.dispose();
    passwordConfirmationFocusNode.dispose();
  }

  bool cpfCnpjEnabled = true;
  void updateCpfCnpjEnabled() {
    if (widget.cpfCnpjController.text.length > 11) {
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
              nameController: widget.nameController,
            ),
            CpfOrCnpjField(
              cpfCnpjFocusNode: cpfCnpjFocusNode,
              reducedNameFocusNode: reducedNameFocusNode,
              updateCpfCnpjEnabled: updateCpfCnpjEnabled,
              validateFormKey: widget.validateFormKey,
              cpfCnpjController: widget.cpfCnpjController,
            ),
            ReducedNameField(
              reducedNameFocusNode: reducedNameFocusNode,
              dateOfBirthFocusNode: dateOfBirthFocusNode,
              validateFormKey: widget.validateFormKey,
              reducedNameController: widget.reducedNameController,
            ),
            BirthField(
              dateOfBirthFocusNode: dateOfBirthFocusNode,
              sexTypeFocusNode: sexTypeFocusNode,
              validateFormKey: widget.validateFormKey,
              dateOfBirthController: widget.dateOfBirthController,
            ),
            Password(
              passwordFocusNode: passwordFocusNode,
              passwordConfirmationFocusNode: passwordConfirmationFocusNode,
              validateFormKey: widget.validateFormKey,
              passwordConfirmationController:
                  widget.passwordConfirmationController,
              passwordController: widget.passwordController,
            ),
            if (cpfCnpjEnabled)
              SexType(
                selectedSexDropDown: _selectedSexDropDown,
                sexTypeFocusNode: sexTypeFocusNode,
                cpfCnpjEnabled: cpfCnpjEnabled,
                validateFormKey: widget.validateFormKey,
              ),
            ClearData(
              nameController: widget.nameController,
              cpfCnpjController: widget.cpfCnpjController,
              reducedNameController: widget.reducedNameController,
              dateOfBirthController: widget.dateOfBirthController,
            ),
          ],
        ),
      ),
    );
  }
}
