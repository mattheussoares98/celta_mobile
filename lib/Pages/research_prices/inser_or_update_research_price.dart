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
  FocusNode codeFocusNode = FocusNode();
  TextEditingController codeController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  TextEditingController nameController = TextEditingController();

  FocusNode observationFocusNode = FocusNode();
  TextEditingController observationController = TextEditingController();

  void _updateControllers(ResearchModel? research) {
    if (research != null) {
      observationController.text = research.Observation;
      codeController.text = research.Code.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    ResearchModel? research =
        ModalRoute.of(context)!.settings.arguments as ResearchModel?;
    _updateControllers(research);
    ResearchPricesProvider researchPricesProvider = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          research == null ? "Cadastrar pesquisa" : "Alterar pesquisa",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                focusNode: codeFocusNode,
                enabled: !researchPricesProvider.isLoadingAddOrUpdateResearch,
                controller: codeController,
                decoration: FormFieldHelper.decoration(
                  isLoading:
                      researchPricesProvider.isLoadingAddOrUpdateResearch,
                  context: context,
                  labelText: 'Código',
                ),
                onFieldSubmitted: (_) async {
                  FocusScope.of(context).requestFocus(nameFocusNode);
                },
                style: FormFieldHelper.style(),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextFormField(
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
                keyboardType: TextInputType.number,
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
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(research == null ? "CADASTRAR" : "ALTERAR"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
