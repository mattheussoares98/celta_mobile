import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../providers/providers.dart';

class ObservationField extends StatelessWidget {
  final FocusNode observationFocusNode;
  final TextEditingController observationController;
  const ObservationField({
    super.key,
    required this.observationFocusNode,
    required this.observationController,
  });

  @override
  Widget build(BuildContext context) {
    ResearchPricesProvider researchPricesProvider = Provider.of(context);
    return TextFormField(
      focusNode: observationFocusNode,
      enabled: !researchPricesProvider.isLoadingAddOrUpdateConcurrents,
      controller: observationController,
      decoration: FormFieldDecoration.decoration(
        context: context,
        labelText: 'Observação',
      ),
      onFieldSubmitted: (_) async {
        FocusScope.of(context).requestFocus();
      },
      style: FormFieldStyle.style(),
    );
  }
}
