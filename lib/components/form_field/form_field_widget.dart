import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components.dart';

class FormFieldWidget extends StatelessWidget {
  final int? limitOfCaracters;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final Widget? suffixWidget;
  final bool? isDate;
  final String labelText;
  final TextEditingController textEditingController;
  final bool enabled;
  final bool? obscureText;
  final bool? autofocus;
  const FormFieldWidget({
    this.onChanged,
    this.keyboardType,
    this.isDate,
    this.suffixWidget,
    this.onFieldSubmitted,
    this.focusNode,
    this.validator,
    this.limitOfCaracters,
    this.obscureText,
    this.autofocus,
    required this.enabled,
    required this.textEditingController,
    required this.labelText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 12, right: 8),
      child: TextFormField(
        enabled: enabled,
        autofocus: autofocus == true,
        controller: textEditingController,
        keyboardType: keyboardType ?? TextInputType.name,
        maxLines: 1,
        onChanged: onChanged,
        obscureText: obscureText == true,
        inputFormatters: limitOfCaracters == null
            ? null
            : isDate != null
                ? [
                    _DateInputFormatter(),
                    LengthLimitingTextInputFormatter(limitOfCaracters),
                  ]
                : [
                    LengthLimitingTextInputFormatter(limitOfCaracters),
                  ],
        focusNode: focusNode ?? null,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator ?? null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: FormFieldStyle.style(),
        decoration: FormFieldDecoration.decoration(
          context: context,
          labelText: labelText,
          suffixIcon: suffixWidget != null ? suffixWidget : null,
        ),
      ),
    );
  }
}

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    final newText = StringBuffer();
    int selectionIndex = newValue.selection.end;

    if (text.isNotEmpty) {
      // Remove caracteres não numéricos
      final cleanText = text.replaceAll(RegExp(r'[^\d]'), '');

      // Adiciona os números com as barras na posição correta
      for (int i = 0; i < cleanText.length; i++) {
        if (i == 2 || i == 4) {
          // Adiciona barras nas posições 2 e 4
          newText.write('/');
          if (selectionIndex >= i) {
            selectionIndex++;
          }
        }
        newText.write(cleanText[i]);
        if (selectionIndex >= i) {
          selectionIndex++;
        }
      }
    }

    // Mantém o cursor no último índice, mesmo ao digitar
    selectionIndex = newText.length;

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
