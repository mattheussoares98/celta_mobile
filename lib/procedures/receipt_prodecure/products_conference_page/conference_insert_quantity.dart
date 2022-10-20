import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductsConferenceInsert extends StatefulWidget {
  const ProductsConferenceInsert({Key? key}) : super(key: key);

  @override
  State<ProductsConferenceInsert> createState() => _ProductsConferenceInsert();
}

class _ProductsConferenceInsert extends State<ProductsConferenceInsert> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static final TextEditingController _consultedProductController =
      TextEditingController();

  final _consultedProductFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _consultedProductFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 3,
              child: Container(
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    autofocus: true,
                    // enabled: quantityProvider.isLoadingQuantity ? false : true,
                    controller: _consultedProductController,
                    focusNode: _consultedProductFocusNode,
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
                      } else if (value.contains('..')) {
                        return 'Carácter inválido';
                      } else if (value.contains(',,')) {
                        return 'Carácter inválido';
                      } else if (value.contains('..')) {
                        return 'Carácter inválido';
                      } else if (value.contains(',.')) {
                        return 'Carácter inválido';
                      } else if (value.contains('.,')) {
                        return 'Carácter inválido';
                      } else if (value.contains('-')) {
                        return 'Carácter inválido';
                      } else if (value.contains(' ')) {
                        return 'Carácter inválido';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Digite a quantidade aqui',
                      errorStyle: const TextStyle(
                        fontSize: 17,
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          style: BorderStyle.solid,
                          width: 2,
                          color: Theme.of(context).colorScheme.primary,
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
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Flexible(
              flex: 1,
              child: Container(
                child: const ElevatedButton(
                  onPressed: null,
                  child: Text("Somar"),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(onPressed: () {}, child: const Text("Anular")),
            ElevatedButton(onPressed: () {}, child: const Text("Subtrair 1")),
            ElevatedButton(onPressed: () {}, child: const Text("Somar 1")),
          ],
        )
      ],
    );
  }
}
