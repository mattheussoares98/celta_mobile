import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InsertQuantityTextFormField extends StatefulWidget {
  final FocusNode focusNode;
  final bool isLoading;
  final TextEditingController textEditingController;
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
    required this.textEditingController,
    required this.formKey,
    required this.onChanged,
    required this.onFieldSubmitted,
    this.isLoading = false,
    this.autoFocus = false,
    this.canReceiveEmptyValue = false,
    this.labelText = "Digite a quantidade",
    this.hintText = "Digite a quantidade",
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
        enabled: widget.isLoading ? false : true,
        controller: widget.textEditingController,
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
          if (value!.isEmpty && !widget.canReceiveEmptyValue) {
            return 'Digite uma quantidade';
          } else if (value == '0' || value == '0.' || value == '0,') {
            return 'Digite uma quantidade';
          } else if (value.contains('.') && value.contains(',')) {
            return 'Carácter inválido';
          } else if (value.contains('-')) {
            return 'Carácter inválido';
          } else if (value.contains(' ')) {
            return 'Carácter inválido';
          } else if (value.characters
                  .toList()
                  .fold<int>(0, (t, e) => e == "." ? t + e.length : t + 0) >
              1) {
            //verifica se tem mais de um ponto
            return 'Carácter inválido';
          } else if (value.characters
                  .toList()
                  .fold<int>(0, (t, e) => e == "," ? t + e.length : t + 0) >
              1) {
            //verifica se tem mais de uma vírgula
            return 'Carácter inválido';
          } else if (double.tryParse(value) == 0) {
            return "Digite uma quantidade";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          floatingLabelStyle: TextStyle(
            color:
                widget.isLoading ? Colors.grey : Theme.of(context).primaryColor,
          ),
          errorStyle: const TextStyle(
            fontSize: 17,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              style: BorderStyle.solid,
              width: 2,
              color: Colors.grey,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              style: BorderStyle.solid,
              width: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          labelStyle: TextStyle(
            color:
                widget.isLoading ? Colors.grey : Theme.of(context).primaryColor,
          ),
        ),
        style: const TextStyle(
          fontSize: 17,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
