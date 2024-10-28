import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components.dart';

class AddSubtractOrAnullWidget extends StatefulWidget {
  final bool isLoading;
  final bool isUpdatingQuantity;
  final FocusNode consultedProductFocusNode;
  final TextEditingController consultedProductController;
  final Function anullFunction;
  final Function addQuantityFunction;
  final Function subtractQuantityFunction;
  final Function onFieldSubmitted;
  final String subtractButtonText;
  final String addButtonText;
  const AddSubtractOrAnullWidget({
    required this.isUpdatingQuantity,
    required this.onFieldSubmitted,
    required this.addQuantityFunction,
    required this.subtractQuantityFunction,
    required this.anullFunction,
    required this.isLoading,
    required this.consultedProductController,
    required this.consultedProductFocusNode,
    required this.subtractButtonText,
    required this.addButtonText,
    Key? key,
  }) : super(key: key);

  @override
  State<AddSubtractOrAnullWidget> createState() => _AddSubtractOrAnullWidget();
}

class _AddSubtractOrAnullWidget extends State<AddSubtractOrAnullWidget> {
  bool isValid() {
    return _formKey.currentState!.validate();
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Flexible(
                  flex: 4,
                  child: AddOrSubtractButton(
                    addButtonText: widget.addButtonText,
                    subtractButtonText: widget.subtractButtonText,
                    isLoading: widget.isUpdatingQuantity,
                    function: () async {
                      await widget.subtractQuantityFunction();
                    },
                    isSubtract: true,
                    formKey: _formKey,
                    isIndividual: false,
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  flex: 10,
                  child: AddOrSubtractButton(
                    addButtonText: widget.addButtonText,
                    subtractButtonText: widget.subtractButtonText,
                    isLoading: widget.isUpdatingQuantity,
                    function: () async {
                      await widget.addQuantityFunction();
                    },
                    isSubtract: false,
                    formKey: _formKey,
                    isIndividual: false,
                  ),
                ),
              ],
            ),
          ),
          Form(
            key: _formKey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  flex: 10,
                  child: Container(
                    child: TextFormField(
                      // autofocus: true,
                      onFieldSubmitted: widget.isLoading
                          ? null
                          : (value) async {
                              await widget.onFieldSubmitted();
                            },
                      enabled: widget.isLoading ? false : true,
                      controller: widget.consultedProductController,
                      focusNode: widget.consultedProductFocusNode,
                      inputFormatters: [LengthLimitingTextInputFormatter(10)],
                      onChanged: (value) {
                        if (value.isEmpty || value == '-') {
                          value = '0';
                        }
                      },
                      validator: (value) {
                        return FormFieldValidations.number(value: value);
                      },
                      decoration: FormFieldDecoration.decoration(
                        isLoading: widget.isLoading,
                        context: context,
                        labelText: 'Quantidade',
                      ),
                      style: FormFieldStyle.style(),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Flexible(
                  flex: 3,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(double.infinity, 50),
                      maximumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: widget.isLoading
                        ? null
                        : () async {
                            await widget.anullFunction();
                          },
                    child: FittedBox(
                      child: Text(
                        widget.isLoading ? "AGUARDE" : "ANULAR",
                        style: const TextStyle(
                          fontSize: 50,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
