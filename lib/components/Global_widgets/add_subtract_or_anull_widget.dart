import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'addOrSubtractButton.dart';

class AddSubtractOrAnullWidget extends StatefulWidget {
  final bool isLoading;
  final bool isUpdatingQuantity;
  final FocusNode consultedProductFocusNode;
  final TextEditingController consultedProductController;
  final GlobalKey<FormState> consultedProductFormKey;
  final Function anullFunction;
  final Function addQuantityFunction;
  final Function subtractQuantityFunction;
  final String subtractButtonText;
  final String addButtonText;
  const AddSubtractOrAnullWidget({
    required this.isUpdatingQuantity,
    required this.addQuantityFunction,
    required this.subtractQuantityFunction,
    required this.anullFunction,
    required this.isLoading,
    required this.consultedProductController,
    required this.consultedProductFormKey,
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
    return widget.consultedProductFormKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Form(
          key: widget.consultedProductFormKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 10,
                child: Container(
                  child: TextFormField(
                    // autofocus: true,
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
                      if (value!.isEmpty) {
                        return 'Digite uma quantidade';
                      } else if (value == '0' ||
                          value == '0.' ||
                          value == '0,') {
                        return 'Digite uma quantidade';
                      } else if (value.contains('.') && value.contains(',')) {
                        return 'Carácter inválido';
                      } else if (value.contains('-')) {
                        return 'Carácter inválido';
                      } else if (value.contains(' ')) {
                        return 'Carácter inválido';
                      } else if (value.characters.toList().fold<int>(
                              0, (t, e) => e == "." ? t + e.length : t + 0) >
                          1) {
                        //verifica se tem mais de um ponto
                        return 'Carácter inválido';
                      } else if (value.characters.toList().fold<int>(
                              0, (t, e) => e == "," ? t + e.length : t + 0) >
                          1) {
                        //verifica se tem mais de uma vírgula
                        return 'Carácter inválido';
                      } else if (!value.contains("1") &&
                          !value.contains("2") &&
                          !value.contains("3") &&
                          !value.contains("4") &&
                          !value.contains("5") &&
                          !value.contains("6") &&
                          !value.contains("7") &&
                          !value.contains("8") &&
                          !value.contains("9")) {
                        return "Digite uma quantidade!";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Digite a quantidade aqui',
                      floatingLabelStyle: TextStyle(
                        color: widget.isLoading
                            ? Colors.grey
                            : Theme.of(context).primaryColor,
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
                        color: widget.isLoading
                            ? Colors.grey
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                    keyboardType: TextInputType.number,
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
        Padding(
          padding: const EdgeInsets.only(top: 10),
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
                  formKey: widget.consultedProductFormKey,
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
                  formKey: widget.consultedProductFormKey,
                  isIndividual: false,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
