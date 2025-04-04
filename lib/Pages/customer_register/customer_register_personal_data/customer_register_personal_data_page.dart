import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../providers/providers.dart';
import 'customer_register_personal_data.dart';

class CustomerRegisterPersonalDataPage extends StatefulWidget {
  final GlobalKey<FormState> personFormKey;
  final void Function() validateFormKey;
  final TextEditingController cpfCnpjController;
  final TextEditingController nameController;
  final TextEditingController passwordConfirmationController;
  final TextEditingController passwordController;
  final TextEditingController reducedNameController;
  final TextEditingController dateOfBirthController;
  final void Function(String) changeCpfCnpj;
  final bool cpfCnpjIsValid;
  final FocusNode cpfCnpjFocusNode;
  final ValueNotifier<String?> selectedSexDropDown;
  final void Function(String?) changeSexDropDown;
  const CustomerRegisterPersonalDataPage({
    required this.personFormKey,
    required this.validateFormKey,
    required this.cpfCnpjController,
    required this.nameController,
    required this.passwordConfirmationController,
    required this.passwordController,
    required this.reducedNameController,
    required this.dateOfBirthController,
    required this.changeCpfCnpj,
    required this.cpfCnpjIsValid,
    required this.cpfCnpjFocusNode,
    required this.selectedSexDropDown,
    required this.changeSexDropDown,
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
  final FocusNode sexTypeFocusNode = FocusNode();
  final FocusNode dateOfBirthFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode passwordConfirmationFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    nameFocusNode.dispose();
    reducedNameFocusNode.dispose();
    sexTypeFocusNode.dispose();
    dateOfBirthFocusNode.dispose();
    passwordFocusNode.dispose();
    passwordConfirmationFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomerRegisterProvider customerRegisterProvider = Provider.of(context);

    return SingleChildScrollView(
      primary: false,
      child: Form(
        key: widget.personFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CpfOrCnpjField(
              cpfCnpjFocusNode: widget.cpfCnpjFocusNode,
              nameFocusNode: nameFocusNode,
              changeCpfCnpj: widget.changeCpfCnpj,
              cpfCnpjController: widget.cpfCnpjController,
            ),
            Visibility(
              visible: widget.cpfCnpjIsValid,
              child: Column(
                children: [
                  NameField(
                    cpfCnpjIsValid: widget.cpfCnpjIsValid,
                    nameFocusNode: nameFocusNode,
                    reducedNameFocusNode: reducedNameFocusNode,
                    validateFormKey: widget.validateFormKey,
                    nameController: widget.nameController,
                  ),
                  ReducedNameField(
                    reducedNameFocusNode: reducedNameFocusNode,
                    cpfCnpjIsValid: widget.cpfCnpjIsValid,
                    dateOfBirthFocusNode: dateOfBirthFocusNode,
                    validateFormKey: widget.validateFormKey,
                    reducedNameController: widget.reducedNameController,
                  ),
                  BirthField(
                    cpfCnpjIsValid: widget.cpfCnpjIsValid,
                    dateOfBirthFocusNode: dateOfBirthFocusNode,
                    passwordFocusNode: passwordFocusNode,
                    validateFormKey: widget.validateFormKey,
                    dateOfBirthController: widget.dateOfBirthController,
                  ),
                  Password(
                    cpfCnpjIsValid: widget.cpfCnpjIsValid,
                    passwordFocusNode: passwordFocusNode,
                    passwordConfirmationFocusNode:
                        passwordConfirmationFocusNode,
                    validateFormKey: widget.validateFormKey,
                    passwordConfirmationController:
                        widget.passwordConfirmationController,
                    passwordController: widget.passwordController,
                    sexTypeFocusNode: sexTypeFocusNode,
                  ),
                  if (widget.cpfCnpjController.text.length == 11)
                    SexType(
                      cpfCnpjIsValid: widget.cpfCnpjIsValid,
                      selectedSexDropDown: widget.selectedSexDropDown,
                      sexTypeFocusNode: sexTypeFocusNode,
                      validateFormKey: widget.validateFormKey,
                      changeSexDropDown: widget.changeSexDropDown,
                    ),
                  ClearData(
                    clearControllers: widget.cpfCnpjIsValid == true
                        ? () {
                            widget.cpfCnpjController.clear();
                            widget.nameController.clear();
                            widget.reducedNameController.clear();
                            widget.dateOfBirthController.clear();
                            widget.passwordController.clear();
                            widget.passwordConfirmationController.clear();

                            customerRegisterProvider
                                .clearPersonalDataControllers();
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
