import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components.dart';

class InsertQuantityTextFormField extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController newQuantityController;
  final String labelText;
  final String hintText;
  final bool autoFocus;
  final GlobalKey formKey;
  final Function onChanged;
  final int lengthLimitingTextInputFormatter;
  final Function onFieldSubmitted;
  final bool canReceiveEmptyValue;
  const InsertQuantityTextFormField({
    required this.focusNode,
    required this.newQuantityController,
    required this.formKey,
    required this.onChanged,
    required this.onFieldSubmitted,
    this.autoFocus = false,
    this.canReceiveEmptyValue = false,
    this.labelText = "Quantidade",
    this.hintText = "Quantidade",
    this.lengthLimitingTextInputFormatter = 10,
    Key? key,
  }) : super(key: key);

  @override
  State<InsertQuantityTextFormField> createState() =>
      _InsertQuantityTextFormFieldState();
}

class _InsertQuantityTextFormFieldState
    extends State<InsertQuantityTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: TextFormField(
        autofocus: widget.autoFocus,
        focusNode: widget.focusNode,
        controller: widget.newQuantityController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        inputFormatters: [
          LengthLimitingTextInputFormatter(
              widget.lengthLimitingTextInputFormatter)
        ],
        onFieldSubmitted: (value) => {
          widget.onFieldSubmitted(),
        },
        onChanged: (value) {
          if (value.isEmpty || value == '-') {
            value = '0';
          }

          widget.onChanged();
        },
        validator: (value) {
          return FormFieldValidations.number(value: value);
        },
        decoration: FormFieldDecoration.decoration(
          context: context,
          labelText: widget.labelText,
          hintText: widget.hintText,
        ),
        style: FormFieldStyle.style(),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }
}
