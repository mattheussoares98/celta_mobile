import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../providers/providers.dart';
import '../../Models/research_prices/research_prices.dart';
import 'components/components.dart';

class ResearchPricesInsertOrUpdateConcurrentPage extends StatefulWidget {
  const ResearchPricesInsertOrUpdateConcurrentPage({super.key});

  @override
  State<ResearchPricesInsertOrUpdateConcurrentPage> createState() =>
      _ResearchPricesInsertOrUpdateConcurrentPageState();
}

class _ResearchPricesInsertOrUpdateConcurrentPageState
    extends State<ResearchPricesInsertOrUpdateConcurrentPage> {
  FocusNode _nameFocusNode = FocusNode();
  TextEditingController nameController = TextEditingController();

  FocusNode observationFocusNode = FocusNode();
  TextEditingController observationController = TextEditingController();

  void _updateControllers(ResearchPricesConcurrentsModel? concurrent) {
    if (concurrent != null) {
      observationController.text = concurrent.Observation ?? "";
      nameController.text = concurrent.Name ?? "";
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

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _nameFocusNode.dispose();
    nameController.dispose();
    observationFocusNode.dispose();
    observationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResearchPricesProvider researchPricesProvider = Provider.of(context);

    return Stack(
      children: [
        PopScope(
          onPopInvokedWithResult: (_, __) {
            researchPricesProvider.updateSelectedConcurrent(concurrent: null);
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
                      NameField(
                        nameFocusNode: _nameFocusNode,
                        observationFocusNode: observationFocusNode,
                        nameController: nameController,
                      ),
                      const SizedBox(height: 8),
                      ObservationField(
                        observationFocusNode: observationFocusNode,
                        observationController: observationController,
                      ),
                      const SizedBox(height: 15),
                      ChangeAddress(),
                      const SizedBox(height: 8),
                      ConfirmOrUpdateButton(
                        formKey: _formKey,
                        nameController: nameController,
                        observationController: observationController,
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
    );
  }
}
