import 'package:celta_inventario/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
import '../../models/research_prices/research_prices.dart';

class InsertOrUpdateResearchPrice extends StatefulWidget {
  const InsertOrUpdateResearchPrice({super.key});

  @override
  State<InsertOrUpdateResearchPrice> createState() =>
      _InsertOrUpdateResearchPriceState();
}

class _InsertOrUpdateResearchPriceState
    extends State<InsertOrUpdateResearchPrice> {
  FocusNode enterpriseNameFocusNode = FocusNode();
  TextEditingController enterpriseNameController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  TextEditingController researchNameController = TextEditingController();

  FocusNode observationFocusNode = FocusNode();
  TextEditingController observationController = TextEditingController();

  void _updateControllers(ResearchModel? research) {
    if (research != null) {
      observationController.text = research.Observation;
      enterpriseNameController.text = research.EnterpriseName ?? "";
      researchNameController.text = research.Name ?? "";
    }
  }

  ResearchModel? research;
  int? enterpriseCode;

  bool _isLoaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isLoaded) {
      _isLoaded = true;
      Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
      research = arguments["research"];
      enterpriseCode = arguments["enterpriseCode"];
      _updateControllers(research);
    }
  }

  @override
  Widget build(BuildContext context) {
    ResearchPricesProvider researchPricesProvider = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          research == null ? "Cadastrar pesquisa" : "Alterar pesquisa",
        ),
        leading: IconButton(
          onPressed: researchPricesProvider.isLoadingAddOrUpdateResearch
              ? null
              : () {
                  Navigator.of(context).pop();
                },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: SingleChildScrollView(
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
                  FocusScope.of(context).requestFocus();
                },
                style: FormFieldHelper.style(),
              ),
              const SizedBox(height: 8),
              TextFormField(
                focusNode: enterpriseNameFocusNode,
                enabled: !researchPricesProvider.isLoadingAddOrUpdateResearch,
                controller: enterpriseNameController,
                decoration: FormFieldHelper.decoration(
                  isLoading:
                      researchPricesProvider.isLoadingAddOrUpdateResearch,
                  context: context,
                  labelText: 'Nome da empresa',
                ),
                onFieldSubmitted: (_) async {
                  FocusScope.of(context).requestFocus();
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
                        await researchPricesProvider.addOrUpdateResearch(
                          context: context,
                          research: research,
                          enterpriseCode: enterpriseCode!,
                          enterpriseName: enterpriseNameController.text,
                          observation: observationController.text,
                          researchName: researchNameController.text,
                        );
                      },
                child: researchPricesProvider.isLoadingAddOrUpdateResearch
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            research == null
                                ? "CADASTRANDO..."
                                : "ALTERARANDO...",
                          ),
                          const SizedBox(height: 8),
                          const LinearProgressIndicator(),
                        ],
                      )
                    : Text(
                        research == null ? "CADASTRAR" : "ALTERAR",
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
