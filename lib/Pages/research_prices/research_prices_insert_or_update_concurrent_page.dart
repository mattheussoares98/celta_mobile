import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
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
  FocusNode _nameFocusNode = FocusNode();
  TextEditingController _nameController = TextEditingController();

  FocusNode _observationFocusNode = FocusNode();
  TextEditingController _observationController = TextEditingController();

  void _updateControllers(ResearchPricesConcurrentsModel? concurrent) {
    if (concurrent != null) {
      _observationController.text = concurrent.Observation ?? "";
      _nameController.text = concurrent.Name ?? "";
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
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _addOrUpdateConcurrent({
    required ResearchPricesProvider researchPricesProvider,
    required AddressProvider addressProvider,
  }) async {
    bool? isValid = _formKey.currentState?.validate();
    if (isValid == false) return;

    ShowAlertDialog.show(
        context: context,
        title: researchPricesProvider.selectedConcurrent == null
            ? "Cadastrar concorrente"
            : "Alterar concorrente",
        subtitle: researchPricesProvider.selectedConcurrent == null
            ? "Deseja realmente cadastrar o concorrente com os dados informados?"
            : "Deseja realmente alterar o concorrente com os dados informados?",
        function: () async {
          await researchPricesProvider.addOrUpdateConcurrent(
            context: context,
            addressProvider: addressProvider,
            concurrentName: _nameController.text,
            observation: _observationController.text,
          );

          if (researchPricesProvider.errorAddOrUpdateConcurrents == "") {
            addressProvider.clearAddresses();
            _nameController.clear();
            _observationController.clear();
            Navigator.of(context).pop();
          } else {
            ShowSnackbarMessage.show(
              message: researchPricesProvider.errorAddOrUpdateConcurrents,
              context: context,
            );
          }
        });
  }

  @override
  void dispose() {
    super.dispose();
    _nameFocusNode.dispose();
    _nameController.dispose();
    _observationFocusNode.dispose();
    _observationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResearchPricesProvider researchPricesProvider = Provider.of(context);
    AddressProvider addressProvider = Provider.of(context, listen: true);

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Stack(
        children: [
          PopScope(
            onPopInvokedWithResult: (_, __) {
              researchPricesProvider.updateSelectedConcurrent(concurrent: null);
              addressProvider.clearAddresses();
              addressProvider.clearAddressControllers(clearCep: true);
            },
            child: Scaffold(
              appBar: AppBar(
                title: FittedBox(
                  child: Text(
                    researchPricesProvider.selectedConcurrent == null
                        ? "Cadastrar concorrente"
                        : "Alterar concorrente (${researchPricesProvider.selectedConcurrent!.ConcurrentCode})",
                  ),
                ),
              ),
              body: SingleChildScrollView(
                primary: false,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          autofocus: false,
                          focusNode: _nameFocusNode,
                          enabled: !researchPricesProvider
                              .isLoadingAddOrUpdateConcurrents,
                          controller: _nameController,
                          decoration: FormFieldDecoration.decoration(
                            isLoading: researchPricesProvider
                                .isLoadingAddOrUpdateConcurrents,
                            context: context,
                            labelText: 'Nome',
                          ),
                          validator: (value) {
                            if (value == null) {
                              return "Digite o nome!";
                            } else if (value.isEmpty) {
                              return "Digite o nome!";
                            } else if (value.length < 3) {
                              return "Mínimo de 3 caracteres";
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) async {
                            FocusScope.of(context).requestFocus(
                              _observationFocusNode,
                            );
                          },
                          style: FormFieldStyle.style(),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          focusNode: _observationFocusNode,
                          enabled: !researchPricesProvider
                              .isLoadingAddOrUpdateConcurrents,
                          controller: _observationController,
                          decoration: FormFieldDecoration.decoration(
                            isLoading: researchPricesProvider
                                .isLoadingAddOrUpdateConcurrents,
                            context: context,
                            labelText: 'Observação',
                          ),
                          onFieldSubmitted: (_) async {
                            FocusScope.of(context).requestFocus();
                          },
                          style: FormFieldStyle.style(),
                        ),
                        const SizedBox(height: 15),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  researchPricesProvider.selectedConcurrent
                                                  ?.Address!.Zip !=
                                              "" &&
                                          researchPricesProvider
                                                  .selectedConcurrent
                                                  ?.Address!
                                                  .Zip !=
                                              null
                                      ? "Alterar endereço"
                                      : "Inserir endereço",
                                  style: const TextStyle(
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
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 20),
                                child: Column(
                                  children: [
                                    AddressComponent(
                                      adressFormKey: _adressFormKey,
                                      canInsertMoreThanOneAddress: false,
                                      isLoading: researchPricesProvider
                                          .isLoadingAddOrUpdateConcurrents,
                                      validateAdressFormKey: () {
                                        return _adressFormKey.currentState!
                                            .validate();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(200, 40),
                          ),
                          onPressed: researchPricesProvider
                                  .isLoadingAddOrUpdateConcurrents
                              ? null
                              : () async {
                                  await _addOrUpdateConcurrent(
                                    researchPricesProvider:
                                        researchPricesProvider,
                                    addressProvider: addressProvider,
                                  );
                                },
                          child: Text(
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
            ),
          ),
          loadingWidget(researchPricesProvider.isLoadingAddOrUpdateConcurrents),
        ],
      ),
    );
  }
}
