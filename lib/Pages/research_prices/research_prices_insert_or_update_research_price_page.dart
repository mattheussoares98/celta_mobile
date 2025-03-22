import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../models/research_prices/research_prices.dart';
import '../../providers/providers.dart';

class ResearchPricesInsertOrUpdateResearchPrice extends StatefulWidget {
  const ResearchPricesInsertOrUpdateResearchPrice({super.key});

  @override
  State<ResearchPricesInsertOrUpdateResearchPrice> createState() =>
      _ResearchPricesInsertOrUpdateResearchPriceState();
}

class _ResearchPricesInsertOrUpdateResearchPriceState
    extends State<ResearchPricesInsertOrUpdateResearchPrice> {
  FocusNode nameFocusNode = FocusNode();
  TextEditingController researchNameController = TextEditingController();

  FocusNode observationFocusNode = FocusNode();
  TextEditingController observationController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _updateControllers(ResearchPricesResearchModel? research) {
    if (research != null) {
      observationController.text = research.Observation ?? "";
      researchNameController.text = research.Name ?? "";
    }
  }

  bool _isLoaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isLoaded) {
      ResearchPricesProvider researchPricesProvider = Provider.of(context);

      _isLoaded = true;
      _updateControllers(researchPricesProvider.selectedResearch);
    }
  }

  Future<void> _insertOrUpdateResearch(
    ResearchPricesProvider researchPricesProvider,
  ) async {
    Map? arguments = ModalRoute.of(context)!.settings.arguments as Map?;

    bool? isValid = _formKey.currentState?.validate();

    if (isValid == false) {
      return;
    }

    ShowAlertDialog.show(
        context: context,
        title: "Confirmar",
        content: const SingleChildScrollView(
          child: Text(
            "Deseja confirmar o cadastro/alteração?",
            textAlign: TextAlign.center,
          ),
        ),
        function: () async {
          await researchPricesProvider.addOrUpdateResearchOfPrice(
            context: context,
            enterpriseCode: arguments?["enterpriseCode"] ?? 0,
            observation: observationController.text,
            name: researchNameController.text,
          );

          if (researchPricesProvider.errorAddOrUpdateOfResearch == "") {
            ShowSnackbarMessage.show(
              message:
                  "${researchPricesProvider.selectedResearch == null ? "Cadastro" : "Alteração"}"
                  "${researchPricesProvider.selectedResearch == null ? " realizado" : " realizada"}"
                  " com sucesso!",
              context: context,
              backgroundColor: Theme.of(context).colorScheme.primary,
            );

            Navigator.of(context).pop(true);
          }
        });
  }

  @override
  void dispose() {
    super.dispose();
    nameFocusNode.dispose();
    researchNameController.dispose();
    observationFocusNode.dispose();
    observationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResearchPricesProvider researchPricesProvider = Provider.of(context);

    return Stack(
      children: [
        PopScope(
          canPop: !researchPricesProvider.isLoadingAddOrUpdateOfResearch,
          onPopInvokedWithResult: (value, __) {
            if (value == true) {
              researchPricesProvider.updateSelectedResearch(null);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: FittedBox(
                child: Text(
                  researchPricesProvider.selectedResearch == null
                      ? "Cadastrar pesquisa"
                      : "Alterar pesquisa",
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
                        autofocus: true,
                        focusNode: nameFocusNode,
                        enabled: !researchPricesProvider
                            .isLoadingAddOrUpdateOfResearch,
                        controller: researchNameController,
                        decoration: FormFieldDecoration.decoration(
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
                            observationFocusNode,
                          );
                        },
                        style: FormFieldStyle.style(),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        focusNode: observationFocusNode,
                        enabled: !researchPricesProvider
                            .isLoadingAddOrUpdateOfResearch,
                        controller: observationController,
                        decoration: FormFieldDecoration.decoration(
                          context: context,
                          labelText: 'Observação',
                        ),
                        onFieldSubmitted: (_) async {
                          FocusScope.of(context).unfocus();
                        },
                        style: FormFieldStyle.style(),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(200, 40),
                        ),
                        onPressed: researchPricesProvider
                                .isLoadingAddOrUpdateOfResearch
                            ? null
                            : () async {
                                await _insertOrUpdateResearch(
                                  researchPricesProvider,
                                );
                              },
                        child: Text(
                          researchPricesProvider.selectedResearch == null
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
        loadingWidget(researchPricesProvider.isLoadingAddOrUpdateOfResearch)
      ],
    );
  }
}
