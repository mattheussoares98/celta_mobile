import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/models.dart';
import '../../Pages/customer_register/customer_register.dart';
import '../components.dart';
import '../../providers/providers.dart';

class AddressComponent extends StatefulWidget {
  final bool canInsertMoreThanOneAddress;
  final List<AddressModel> addresses;
  final bool Function(AddressModel address) addAddress;
  const AddressComponent({
    required this.canInsertMoreThanOneAddress,
    required this.addresses,
    required this.addAddress,
    Key? key,
  }) : super(key: key);

  @override
  State<AddressComponent> createState() => _AddressComponentState();
}

class _AddressComponentState extends State<AddressComponent> {
  final zipController = TextEditingController();
  final numberController = TextEditingController();
  final cityController = TextEditingController();
  final districtController = TextEditingController();
  final addressController = TextEditingController();
  final complementController = TextEditingController();
  final referenceController = TextEditingController();
  final areaCodeController = TextEditingController();

  final cepFocusNode = FocusNode();
  final addressFocusNode = FocusNode();
  final districtFocusNode = FocusNode();
  final stateFocusNode = FocusNode();
  final cityFocusNode = FocusNode();
  final numberFocusNode = FocusNode();
  final complementFocusNode = FocusNode();
  final referenceFocusNode = FocusNode();

  ValueNotifier<String?> selectedStateNotifier = ValueNotifier<String?>("");
  final formKey = GlobalKey<FormState>();

  bool triedGetCep = false;

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

    zipController.dispose();
    numberController.dispose();
    cityController.dispose();
    districtController.dispose();
    addressController.dispose();
    complementController.dispose();
    referenceController.dispose();
    areaCodeController.dispose();
  }

  Future<void> _getAdressByCep({
    required AddressProvider addressProvider,
  }) async {
    if (!widget.canInsertMoreThanOneAddress && widget.addresses.length > 0) {
      ShowSnackbarMessage.show(
        message:
            "Não é possível inserir mais de um endereço! Remova o endereço informado para conseguir adicionar outro!",
        context: context,
      );
      return;
    }

    AddressModel? addressModel = await addressProvider.getAddressByCep(
      context: context,
      cep: zipController.text,
    );

    setState(() {
      triedGetCep = true;
    });

    cityController.text = addressModel?.City ?? "";
    districtController.text = addressModel?.District ?? "";
    addressController.text = addressModel?.Address ?? "";
    complementController.text = addressModel?.Complement ?? "";
    referenceController.text = addressModel?.Reference ?? "";

    final states =
        addressProvider.states.where((e) => e == addressModel?.State);
    if (states.isNotEmpty) {
      selectedStateNotifier.value = states.first;
    } else {
      selectedStateNotifier.value = null;
    }
    if (addressModel != null) {
      Future.delayed(Duration.zero, () {
        numberFocusNode.requestFocus();
      });
    }
  }

  void clearControllers() {
    zipController.clear();
    numberController.clear();
    cityController.clear();
    districtController.clear();
    addressController.clear();
    complementController.clear();
    referenceController.clear();
    selectedStateNotifier.value = null;
  }

  @override
  Widget build(BuildContext context) {
    AddressProvider addressProvider = Provider.of(context);
    return SingleChildScrollView(
      primary: false,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            CepField(
              zipController: zipController,
              cepFocusNode: cepFocusNode,
              getAdressByCep: () async {
                await _getAdressByCep(addressProvider: addressProvider);
              },
            ),
            if (triedGetCep)
              Column(
                children: [
                  AddressField(
                    cepController: zipController,
                    addressController: addressController,
                    districtFocusNode: districtFocusNode,
                    addressFocusNode: addressFocusNode,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DistrictField(
                          cepController: zipController,
                          districtController: districtController,
                          districtFocusNode: districtFocusNode,
                          cityFocusNode: cityFocusNode,
                        ),
                      ),
                      Expanded(
                        child: CityField(
                          cepController: zipController,
                          cityController: cityController,
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
                          areaCodeController: areaCodeController,
                          selectedState: selectedStateNotifier,
                        ),
                      ),
                      Expanded(
                        child: NumberField(
                          zipController: zipController,
                          numberController: numberController,
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
                          complementFocusNode: complementFocusNode,
                          referenceFocusNode: referenceFocusNode,
                        ),
                      ),
                      Expanded(
                        child: ReferenceField(
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
                          formKey: formKey,
                          addAddress: () {
                            if (formKey.currentState?.validate() != true) {
                              return;
                            }

                            bool added = widget.addAddress(
                              AddressModel(
                                Zip: zipController.text,
                                Address: addressController.text,
                                Number: numberController.text,
                                District: districtController.text,
                                City: cityController.text,
                                State: selectedStateNotifier.value,
                                Complement: complementController.text,
                                Reference: referenceController.text,
                              ),
                            );
                            if (added) {
                              setState(() {
                                triedGetCep = false;
                              });
                              clearControllers();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            if (widget.addresses.length > 0)
              CustomerRegisterAddressesInformeds(
                addresses: widget.addresses,
              ),
          ],
        ),
      ),
    );
  }
}
