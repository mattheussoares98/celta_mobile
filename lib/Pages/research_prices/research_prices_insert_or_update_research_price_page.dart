import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
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

  void _updateControllers(ResearchModel? research) {
    if (research != null) {
      observationController.text = research.Observation;
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

  @override
  Widget build(BuildContext context) {
    ResearchPricesProvider researchPricesProvider = Provider.of(context);
    Map? arguments = ModalRoute.of(context)!.settings.arguments as Map?;

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text(
            researchPricesProvider.selectedResearch == null
                ? "Cadastrar pesquisa"
                : "Alterar pesquisa",
          ),
        ),
        leading: IconButton(
          onPressed: researchPricesProvider.isLoadingAddOrUpdateResearch
              ? null
              : () {
                  researchPricesProvider.updateSelectedResearch(null);
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
          researchPricesProvider.updateSelectedResearch(null);
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
                  controller: researchNameController,
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
                    FocusScope.of(context).unfocus();
                  },
                  style: FormFieldHelper.style(),
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
                              title: "Confirmar",
                              subtitle:
                                  "Deseja confirmar o cadastro/alteração?",
                              function: () async {
                                await researchPricesProvider
                                    .addOrUpdateResearch(
                                  context: context,
                                  enterpriseCode:
                                      arguments?["enterpriseCode"] ?? 0,
                                  observation: observationController.text,
                                  researchName: researchNameController.text,
                                  isAssociatingConcurrents: false,
                                );

                                if (researchPricesProvider
                                        .errorAddOrUpdateResearch ==
                                    "") {
                                  ShowSnackbarMessage.showMessage(
                                    message:
                                        "Cadastro/alteração realizado com sucesso!",
                                    context: context,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                  );

                                  Navigator.of(context).pop(true);
                                }
                              });
                        },
                  child: researchPricesProvider.isLoadingAddOrUpdateResearch
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              researchPricesProvider.selectedResearch == null
                                  ? "CADASTRANDO..."
                                  : "ALTERARANDO...",
                            ),
                            const SizedBox(height: 8),
                            const LinearProgressIndicator(),
                          ],
                        )
                      : Text(
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
    );
  }
}
