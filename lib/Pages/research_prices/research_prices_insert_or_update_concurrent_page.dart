import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
import '../../providers/providers.dart';
import '../../models/research_prices/research_prices.dart';

class ResearchPricesInsertOrUpdateConcurrentPage extends StatefulWidget {
  const ResearchPricesInsertOrUpdateConcurrentPage({super.key});

  @override
  State<ResearchPricesInsertOrUpdateConcurrentPage> createState() =>
      _ResearchPricesInsertOrUpdateConcurrentPageState();
}

class _ResearchPricesInsertOrUpdateConcurrentPageState
    extends State<ResearchPricesInsertOrUpdateConcurrentPage> {
  FocusNode nameFocusNode = FocusNode();
  TextEditingController nameController = TextEditingController();

  FocusNode observationFocusNode = FocusNode();
  TextEditingController observationController = TextEditingController();

  void _updateControllers(ConcurrentsModel? concurrent) {
    if (concurrent != null) {
      observationController.text = concurrent.Observation;
      nameController.text = concurrent.Name;
    }
  }

  bool _isLoaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isLoaded) {
      ResearchPricesProvider researchPricesProvider = Provider.of(context);

      _isLoaded = true;

      _updateControllers(researchPricesProvider.selectedConcurrent);
    }
  }

  GlobalKey<FormState> _adressFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ResearchPricesProvider researchPricesProvider = Provider.of(context);
    AddressProvider addressProvider = Provider.of(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text(
            researchPricesProvider.selectedConcurrent == null
                ? "Cadastrar concorrente"
                : "Alterar concorrente",
          ),
        ),
        leading: IconButton(
          onPressed: researchPricesProvider.isLoadingAddOrUpdateResearch
              ? null
              : () {
                  researchPricesProvider.updateSelectedConcurrent(null);
                  addressProvider.clearAddresses();
                  addressProvider.clearAddressControllers(clearCep: true);
                  Navigator.of(context).pop();
                },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: PopScope(
        canPop: true,
        onPopInvoked: ((didPop) {
          researchPricesProvider.updateSelectedConcurrent(null);
          addressProvider.clearAddresses();
          addressProvider.clearAddressControllers(clearCep: true);
        }),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  autofocus: true,
                  focusNode: nameFocusNode,
                  enabled: !researchPricesProvider.isLoadingAddOrUpdateResearch,
                  controller: nameController,
                  decoration: FormFieldHelper.decoration(
                    isLoading:
                        researchPricesProvider.isLoadingAddOrUpdateResearch,
                    context: context,
                    labelText: 'Nome',
                  ),
                  onFieldSubmitted: (_) async {
                    FocusScope.of(context).requestFocus(
                      observationFocusNode,
                    );
                  },
                  style: FormFieldHelper.style(),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  focusNode: observationFocusNode,
                  enabled: !researchPricesProvider.isLoadingAddOrUpdateResearch,
                  controller: observationController,
                  decoration: FormFieldHelper.decoration(
                    isLoading:
                        researchPricesProvider.isLoadingAddOrUpdateResearch,
                    context: context,
                    labelText: 'Observação',
                  ),
                  onFieldSubmitted: (_) async {
                    FocusScope.of(context).requestFocus();
                  },
                  style: FormFieldHelper.style(),
                ),
                const SizedBox(height: 15),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Endereço",
                      style: TextStyle(
                        color: Color.fromARGB(255, 126, 126, 126),
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 20),
                    child: Column(
                      children: [
                        AddressComponent(
                          adressFormKey: _adressFormKey,
                          canInsertMoreThanOneAddress: false,
                          validateAdressFormKey: () {
                            return _adressFormKey.currentState!.validate();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 40),
                  ),
                  onPressed: researchPricesProvider.isLoadingAddOrUpdateResearch
                      ? null
                      : () async {
                          ShowAlertDialog.showAlertDialog(
                              context: context,
                              title:
                                  researchPricesProvider.selectedConcurrent ==
                                          null
                                      ? "Cadastrar concorrente"
                                      : "Alterar concorrente",
                              subtitle: researchPricesProvider
                                          .selectedConcurrent ==
                                      null
                                  ? "Deseja realmente cadastrar o concorrente com os dados informados?"
                                  : "Deseja realmente alterar o concorrente com os dados informados?",
                              function: () async {
                                await researchPricesProvider
                                    .addOrUpdateConcurrent(
                                  context: context,
                                  address: addressProvider.addresses[0],
                                  concurrentName: nameController.text,
                                  observation: observationController.text,
                                );

                                if (researchPricesProvider
                                        .errorAddOrUpdateConcurrents ==
                                    "") {
                                  addressProvider.clearAddresses();
                                  nameController.clear();
                                  observationController.clear();
                                  Navigator.of(context).pop();
                                }
                              });
                        },
                  child: researchPricesProvider.isLoadingAddOrUpdateResearch
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              researchPricesProvider.selectedConcurrent == null
                                  ? "CADASTRANDO..."
                                  : "ALTERARANDO...",
                            ),
                            const SizedBox(height: 8),
                            const LinearProgressIndicator(),
                          ],
                        )
                      : Text(
                          researchPricesProvider.selectedConcurrent == null
                              ? "CADASTRAR"
                              : "ALTERAR",
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
