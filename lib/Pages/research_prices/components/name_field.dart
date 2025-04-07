import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../providers/providers.dart';

class NameField extends StatelessWidget {
  final FocusNode nameFocusNode;
  final FocusNode observationFocusNode;
  final TextEditingController nameController;
  const NameField({
    super.key,
    required this.nameFocusNode,
    required this.observationFocusNode,
    required this.nameController,
  });

  @override
  Widget build(BuildContext context) {
    ResearchPricesProvider researchPricesProvider = Provider.of(context);

    return TextFormField(
      autofocus: false,
      focusNode: nameFocusNode,
      enabled: !researchPricesProvider.isLoadingAddOrUpdateConcurrents,
      controller: nameController,
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
    );
  }
}
