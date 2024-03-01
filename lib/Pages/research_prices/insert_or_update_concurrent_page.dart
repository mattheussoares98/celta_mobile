import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
import '../../providers/providers.dart';
import '../../models/research_prices/research_prices.dart';

class InsertOrUpdateConcurrentPage extends StatefulWidget {
  const InsertOrUpdateConcurrentPage({super.key});

  @override
  State<InsertOrUpdateConcurrentPage> createState() =>
      _InsertOrUpdateConcurrentPageState();
}

class _InsertOrUpdateConcurrentPageState
    extends State<InsertOrUpdateConcurrentPage> {
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

  int? enterpriseCode;

  bool _isLoaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isLoaded) {
      ResearchPricesProvider researchPricesProvider = Provider.of(context);

      _isLoaded = true;
      enterpriseCode = ModalRoute.of(context)!.settings.arguments as int;

      _updateControllers(researchPricesProvider.selectedConcurrent);
    }
  }

  @override
  Widget build(BuildContext context) {
    ResearchPricesProvider researchPricesProvider = Provider.of(context);

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
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 40),
                ),
                onPressed: researchPricesProvider.isLoadingAddOrUpdateResearch
                    ? null
                    : () async {
                        await researchPricesProvider.addOrUpdateConcurrent(
                            context: context);
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
    );
  }
}
