import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Pages/customer_register/customer_register.dart';
import '../components.dart';
import '../../providers/providers.dart';

class AddressComponent extends StatefulWidget {
  final GlobalKey<FormState> adressFormKey;
  final bool Function() validateAdressFormKey;
  final bool canInsertMoreThanOneAddress;
  final bool? isLoading;
  const AddressComponent({
    required this.adressFormKey,
    this.isLoading = false,
    required this.validateAdressFormKey,
    required this.canInsertMoreThanOneAddress,
    Key? key,
  }) : super(key: key);

  @override
  State<AddressComponent> createState() => _AddressComponentState();
}

class _AddressComponentState extends State<AddressComponent> {
  final cepController = TextEditingController();
  final numberController = TextEditingController();
  final cityController = TextEditingController();
  final districtController = TextEditingController();
  final addressController = TextEditingController();
  final complementController = TextEditingController();
  final referenceController = TextEditingController();

  final cepFocusNode = FocusNode();
  final addressFocusNode = FocusNode();
  final districtFocusNode = FocusNode();
  final stateFocusNode = FocusNode();
  final cityFocusNode = FocusNode();
  final numberFocusNode = FocusNode();
  final complementFocusNode = FocusNode();
  final referenceFocusNode = FocusNode();

  ValueNotifier<String?> _selectedStateNotifier = ValueNotifier<String?>("");

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    AddressProvider addressProvider = Provider.of(context, listen: true);
    _selectedStateNotifier.value = addressProvider.selectedStateDropDown.value;
  }

  @override
  void dispose() {
    super.dispose();
    cepFocusNode.dispose();
    addressFocusNode.dispose();
    districtFocusNode.dispose();
    stateFocusNode.dispose();
    cityFocusNode.dispose();
    numberFocusNode.dispose();
    complementFocusNode.dispose();
    referenceFocusNode.dispose();

    cepController.dispose();
    numberController.dispose();
    cityController.dispose();
    districtController.dispose();
    addressController.dispose();
    complementController.dispose();
    referenceController.dispose();
  }

  Future<void> _getAdressByCep({
    required AddressProvider addressProvider,
  }) async {
    if (!widget.canInsertMoreThanOneAddress &&
        addressProvider.addressesCount > 0) {
      ShowSnackbarMessage.show(
        message:
            "Não é possível inserir mais de um endereço! Remova o endereço informado para conseguir adicionar outro!",
        context: context,
      );
      return;
    }

    await addressProvider.getAddressByCep(
      context: context,
      cep: cepController.text,
    );

    if (addressProvider.errorMessage == "") {
      Future.delayed(const Duration(milliseconds: 100), () {
        FocusScope.of(context).requestFocus(numberFocusNode);
      });
    } else {
      ShowSnackbarMessage.show(
        message: addressProvider.errorMessage,
        context: context,
      );
    }
  }

  void clearControllers() {
    cepController.clear();
    numberController.clear();
    cityController.clear();
    districtController.clear();
    addressController.clear();
    complementController.clear();
    referenceController.clear();
  }

  @override
  Widget build(BuildContext context) {
    AddressProvider addressProvider = Provider.of(context);
    return SingleChildScrollView(
      primary: false,
      child: Form(
        key: widget.adressFormKey,
        child: Column(
          children: [
            CepField(
              cepController: cepController,
              cepFocusNode: cepFocusNode,
              getAdressByCep: () async {
                await _getAdressByCep(addressProvider: addressProvider);
              },
            ),
            if (addressProvider.triedGetCep)
              Column(
                children: [
                  AddressField(
                    cepController: cepController,
                    addressController: addressController,
                    isLoading: widget.isLoading == true,
                    districtFocusNode: districtFocusNode,
                    addressFocusNode: addressFocusNode,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DistrictField(
                          cepController: cepController,
                          districtController: districtController,
                          isLoading: widget.isLoading == true,
                          districtFocusNode: districtFocusNode,
                          cityFocusNode: cityFocusNode,
                        ),
                      ),
                      Expanded(
                        child: CityField(
                          cepController: cepController,
                          cityController: cityController,
                          isLoading: widget.isLoading == true,
                          cityFocusNode: cityFocusNode,
                          stateFocusNode: stateFocusNode,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: StateDropDown(
                          stateFocusNode: stateFocusNode,
                          selectedState: _selectedStateNotifier,
                        ),
                      ),
                      Expanded(
                        child: NumberField(
                          cepController: cepController,
                          numberController: numberController,
                          isLoading: widget.isLoading == true,
                          numberFocusNode: numberFocusNode,
                          complementFocusNode: complementFocusNode,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ComplementField(
                          complementController: complementController,
                          isLoading: widget.isLoading == true,
                          complementFocusNode: complementFocusNode,
                          referenceFocusNode: referenceFocusNode,
                        ),
                      ),
                      Expanded(
                        child: ReferenceField(
                          isLoading: widget.isLoading == true,
                          referenceFocusNode: referenceFocusNode,
                          referenceController: referenceController,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CleanWrittenDataButton(
                          clearControllers: clearControllers,
                        ),
                        AddAddressButton(
                          validateAdressFormKey: widget.validateAdressFormKey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            if (addressProvider.addressesCount > 0)
              CustomerRegisterAddressesInformeds(
                isLoading: widget.isLoading == true,
              ),
          ],
        ),
      ),
    );
  }
}
