import 'package:celta_inventario/Models/conference_product_model.dart';
import 'package:celta_inventario/providers/conference_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConferenceInsertQuantityWidget extends StatefulWidget {
  final ConferenceProvider conferenceProvider;
  final ConferenceProductModel conferenceProductModel;
  final int docCode;
  final int index;
  const ConferenceInsertQuantityWidget({
    required this.docCode,
    required this.conferenceProvider,
    required this.conferenceProductModel,
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  State<ConferenceInsertQuantityWidget> createState() =>
      _ConferenceInsertQuantityWidget();
}

class _ConferenceInsertQuantityWidget
    extends State<ConferenceInsertQuantityWidget> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static final TextEditingController _consultedProductController =
      TextEditingController();

  final _consultedProductFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _consultedProductFocusNode.dispose();
  }

  bool isValid() {
    return _formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 10,
              child: Container(
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    autofocus: true,
                    enabled: widget.conferenceProvider.isUpdatingQuantity
                        ? false
                        : true,
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
                      floatingLabelStyle: TextStyle(
                        color: widget.conferenceProvider.consultingProducts ||
                                widget.conferenceProvider.isUpdatingQuantity
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
                        color: widget.conferenceProvider.consultingProducts ||
                                widget.conferenceProvider.isUpdatingQuantity
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
            ),
            const SizedBox(width: 5),
            Flexible(
              flex: 4,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  minimumSize: const Size(double.infinity, 50),
                  maximumSize: const Size(double.infinity, 50),
                ),
                onPressed: widget.conferenceProvider.isUpdatingQuantity
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        await widget.conferenceProvider.anullQuantity(
                          docCode: widget.docCode,
                          productgCode: widget
                              .conferenceProductModel.CodigoInterno_Produto,
                          productPackingCode: widget
                              .conferenceProductModel.CodigoInterno_ProEmb,
                          index: widget.index,
                          context: context,
                        );

                        if (widget.conferenceProvider
                                .errorMessageUpdateQuantity ==
                            "") {
                          _consultedProductController.clear();
                        }
                      },
                child: FittedBox(
                  child: Text(
                    widget.conferenceProvider.isUpdatingQuantity
                        ? "AGUARDE"
                        : "ANULAR",
                    style: const TextStyle(
                      fontSize: 50,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Flexible(
              flex: 7,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // primary: Colors.red,
                  minimumSize: const Size(double.infinity, 50),
                  maximumSize: const Size(double.infinity, 50),
                ),
                onPressed: widget.conferenceProvider.isUpdatingQuantity
                    ? null
                    : () async {
                        if (!isValid()) return;
                        FocusScope.of(context).unfocus();
                        await widget.conferenceProvider.updateQuantity(
                          docCode: widget.docCode,
                          productgCode: widget
                              .conferenceProductModel.CodigoInterno_Produto,
                          productPackingCode: widget
                              .conferenceProductModel.CodigoInterno_ProEmb,
                          quantityText: _consultedProductController.text,
                          index: widget.index,
                          context: context,
                        );

                        if (widget.conferenceProvider
                                .errorMessageUpdateQuantity ==
                            "") {
                          _consultedProductController.clear();
                        }
                      },
                child: FittedBox(
                  child: Text(
                    widget.conferenceProvider.isUpdatingQuantity
                        ? "AGUARDE"
                        : "Alterar",
                    style: const TextStyle(
                      fontSize: 50,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
