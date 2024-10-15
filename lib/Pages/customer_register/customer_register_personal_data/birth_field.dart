import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../components/components.dart';

class BirthField extends StatelessWidget {
  final FocusNode dateOfBirthFocusNode;
  final FocusNode sexTypeFocusNode;
  final void Function() validateFormKey;
  final TextEditingController dateOfBirthController;

  const BirthField({
    required this.dateOfBirthFocusNode,
    required this.sexTypeFocusNode,
    required this.validateFormKey,
    required this.dateOfBirthController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FormFieldWidget(
      keyboardType: TextInputType.number,
      enabled: true,
      focusNode: dateOfBirthFocusNode,
      onChanged: (_) {
        validateFormKey();
      },
      onFieldSubmitted: (String? value) {
        FocusScope.of(context).requestFocus(sexTypeFocusNode);
      },
      labelText: "Nascimento",
      isDate: true,
      textEditingController: dateOfBirthController,
      limitOfCaracters: 10,
      suffixWidget: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                icon: Icon(
                  Icons.calendar_month,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () async {
                  DateTime? validityDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now().subtract(
                      const Duration(days: 36500),
                    ),
                    initialDate:
                        DateTime.now().subtract(const Duration(days: 1825)),
                    lastDate:
                        DateTime.now().subtract(const Duration(days: 1825)),
                    locale: const Locale('pt', 'BR'),
                  );

                  if (validityDate != null) {
                    dateOfBirthController.text =
                        DateFormat('dd/MM/yyyy').format(validityDate);
                  }
                }),
            IconButton(
              onPressed: () {
                dateOfBirthController.text = "";
                FocusScope.of(context).requestFocus(dateOfBirthFocusNode);
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return null;
        }

        // Verifique se a data está no formato correto (XX/XX/XXXX)
        final datePattern = RegExp(r'^\d{2}/\d{2}/\d{4}$');
        if (!datePattern.hasMatch(value)) {
          return 'Data inválida!';
        }

        // Divida a data em dia, mês e ano
        final parts = value.split('/');
        final day = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final year = int.tryParse(parts[2]);

        if (day == null || month == null || year == null) {
          return 'Data inválida!';
        }

        // Verifique se o dia está no intervalo correto (01-31)
        if (day < 1 || day > 31) {
          return 'Dia inválido!';
        }

        // Verifique se o mês está no intervalo correto (01-12)
        if (month < 1 || month > 12) {
          return 'Mês inválido!';
        }

        // Verifique se o ano está no intervalo correto (5 anos atrás até 100 anos no futuro)
        final currentYear = DateTime.now().year;
        if (year > currentYear - 5 || year > currentYear + 100) {
          return 'Ano inválido!';
        }

        return null; // A data é válida
      },
    );
  }
}
